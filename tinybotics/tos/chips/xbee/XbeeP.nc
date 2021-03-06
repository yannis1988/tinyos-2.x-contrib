/*									
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Intel Open Source License 
 *
 *  Copyright (c) 2002 Intel Corporation 
 *  All rights reserved. 
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 * 
 *	Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *      Neither the name of the Intel Corporation nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * Revision: $Revision$
 * 
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * perform XBee API framing
 * @author Phil Buonadonna
 * @author Lewis Girod
 * @author Ben Greenstein
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */

/*
 TXSTATE_PROTO and RXSTATE_PROTO respectively puts and checks MSB=0
 ACKs are disabled
 CRC is 1 byte long and calculated with a different, simpler function

 still needs a lot of polishing!
 */


#include "AM.h"
//#include "crc.h"

module XbeeP {

  provides {
    interface Init;
    interface SplitControl;
    interface SendBytePacket;
    interface ReceiveBytePacket;
  }

  uses {
    interface SerialFrameComm;
    interface Leds;
    interface StdControl as SerialControl;
    interface SerialFlush;
    interface SplitControl as XbeeControl;
  }
}
implementation {
#define NO_TX_SEQNO

  enum {
    RX_DATA_BUFFER_SIZE = 2,
    TX_DATA_BUFFER_SIZE = 4,
    SERIAL_MTU = 255,
    SERIAL_VERSION = 1,
    ACK_QUEUE_SIZE = 5,
  };

  enum {
    RXSTATE_NOSYNC,
    RXSTATE_PROTO,
    RXSTATE_TOKEN,
    RXSTATE_API,  // added to handle eventual API check ...
    RXSTATE_INFO,
    RXSTATE_INACTIVE
  };

  enum {
    TXSTATE_IDLE,
    TXSTATE_PROTO,
    TXSTATE_SEQNO,
    TXSTATE_INFO,
    TXSTATE_FCS1,
    TXSTATE_FCS2,
    TXSTATE_ENDFLAG,
    TXSTATE_ENDWAIT,
    TXSTATE_FINISH,
    TXSTATE_ERROR,
    TXSTATE_INACTIVE
  };

  typedef enum {
    BUFFER_AVAILABLE,
    BUFFER_FILLING,
    BUFFER_COMPLETE,
  } tx_data_buffer_states_t;

  enum {
    TX_ACK_INDEX = 0,
    TX_DATA_INDEX = 1,
    TX_BUFFER_COUNT = 2,
  };


  typedef struct {
    uint8_t writePtr;
    uint8_t readPtr;
    uint8_t buf[RX_DATA_BUFFER_SIZE+1]; // one wasted byte: writePtr == readPtr means empty
  } rx_buf_t;

  typedef struct {
    uint8_t state;
    uint8_t buf;    
  } tx_buf_t;
  
  typedef struct {
    uint8_t writePtr;
    uint8_t readPtr;
    uint8_t buf[ACK_QUEUE_SIZE+1]; // one wasted byte: writePtr == readPtr means empty    
  } ack_queue_t;

  /* Buffers */

  rx_buf_t rxBuf;
  tx_buf_t txBuf[TX_BUFFER_COUNT];

  /* Receive State */

  uint8_t  rxState;
  uint8_t  rxByteCnt;
  uint8_t  rxProto;
  uint8_t  rxSeqno;
  uint8_t rxCRC;
  uint8_t  rxLen; // length of the packet = LSB in XBee API

  /* Transmit State */

  norace uint8_t  txState;
  norace uint8_t  txByteCnt;
  norace uint8_t  txProto;
  norace uint8_t  txSeqno;
  norace uint8_t txCRC;
  uint8_t  txPending;
  norace uint8_t txIndex;
  
  /* Ack Queue */
  ack_queue_t ackQ;

  bool offPending = FALSE;

  // Prototypes

  inline void txInit();
  inline void rxInit();
  inline void ackInit();

  inline bool ack_queue_is_full(); 
  inline bool ack_queue_is_empty(); 
  inline void ack_queue_push(uint8_t token);
  inline uint8_t ack_queue_top();
  uint8_t ack_queue_pop();

  inline void rx_buffer_init();
  inline bool rx_buffer_is_full();
  inline bool rx_buffer_is_empty();
  inline void rx_buffer_push(uint8_t data);
  inline uint8_t rx_buffer_top();
  inline uint8_t rx_buffer_pop();
  inline uint16_t rx_current_crc();

  void rx_state_machine(bool isDelimeter, uint8_t data);
  void MaybeScheduleTx();
  task void RunTx();
  


  inline void txInit(){
    uint8_t i;
    atomic for (i = 0; i < TX_BUFFER_COUNT; i++) txBuf[i].state = BUFFER_AVAILABLE;
    txState = TXSTATE_IDLE;
    txByteCnt = 0;
    txProto = 0;
    txSeqno = 0;
    txCRC = 0; 
    txPending = FALSE;
    txIndex = 0;
  }

  inline void rxInit(){
    rxBuf.writePtr = rxBuf.readPtr = 0;
    rxState = RXSTATE_NOSYNC;
    rxByteCnt = 0;
    rxProto = 0;
    rxSeqno = 0;
    rxCRC = 0;
  }

  inline void ackInit(){
    ackQ.writePtr = ackQ.readPtr = 0;
  }

  command error_t Init.init() {

    txInit();
    rxInit();
    ackInit();
    return SUCCESS;
  }


  /*
   *  buffer and queue manipulation
   */

  inline bool ack_queue_is_full(){ 
    uint8_t tmp, tmp2;
    atomic {
      tmp = ackQ.writePtr;
      tmp2 = ackQ.readPtr;
    }
    if (++tmp > ACK_QUEUE_SIZE) tmp = 0;
    return (tmp == tmp2);
  }

  inline bool ack_queue_is_empty(){
    bool ret;
    atomic ret = (ackQ.writePtr == ackQ.readPtr); 
    return ret;
  }

  inline void ack_queue_push(uint8_t token) {
    if (!ack_queue_is_full()){
      atomic {
        ackQ.buf[ackQ.writePtr] = token;
        if (++ackQ.writePtr > ACK_QUEUE_SIZE) ackQ.writePtr = 0;
      }
      MaybeScheduleTx();
    }
  }

  inline uint8_t ack_queue_top() {
    uint8_t tmp = 0;
    atomic {
      if (!ack_queue_is_empty()){
        tmp =  ackQ.buf[ackQ.readPtr];
      }
    }
    return tmp;
  }

  uint8_t ack_queue_pop() {
    uint8_t retval = 0;
    atomic {
      if (ackQ.writePtr != ackQ.readPtr){
        retval =  ackQ.buf[ackQ.readPtr];
        if (++(ackQ.readPtr) > ACK_QUEUE_SIZE) ackQ.readPtr = 0;
      }
    }
    return retval;
  }


  /* 
   * Buffer Manipulation
   */

  inline void rx_buffer_init(){
    rxBuf.writePtr = rxBuf.readPtr = 0;
  }
  inline bool rx_buffer_is_full() {
    uint8_t tmp = rxBuf.writePtr;
    if (++tmp > RX_DATA_BUFFER_SIZE) tmp = 0;
    return (tmp == rxBuf.readPtr);
  }
  inline bool rx_buffer_is_empty(){
    return (rxBuf.readPtr == rxBuf.writePtr);
  }
  inline void rx_buffer_push(uint8_t data){
    rxBuf.buf[rxBuf.writePtr] = data;
    if (++(rxBuf.writePtr) > RX_DATA_BUFFER_SIZE) rxBuf.writePtr = 0;
  }
  inline uint8_t rx_buffer_top(){
    uint8_t tmp = rxBuf.buf[rxBuf.readPtr];
    return tmp;
  }
  inline uint8_t rx_buffer_pop(){
    uint8_t tmp = rxBuf.buf[rxBuf.readPtr];
    if (++(rxBuf.readPtr) > RX_DATA_BUFFER_SIZE) rxBuf.readPtr = 0;
    return tmp;
  }
  
  inline uint16_t rx_current_crc(){
    uint16_t crc;
    uint8_t tmp = rxBuf.writePtr;
    tmp = (tmp == 0 ? RX_DATA_BUFFER_SIZE : tmp - 1);
    crc = rxBuf.buf[tmp] & 0x00ff;
    crc = (crc << 8) & 0xFF00;
    tmp = (tmp == 0 ? RX_DATA_BUFFER_SIZE : tmp - 1);
    crc |= (rxBuf.buf[tmp] & 0x00FF);
    return crc;
  }

  task void startDoneTask() {
    call SerialControl.start();
    // module configuration (panId, nodeId, etc)
    call XbeeControl.start();
  }

  event void XbeeControl.startDone(error_t error) {
    signal SplitControl.startDone(SUCCESS);
  }

  event void XbeeControl.stopDone(error_t error) {
    return;
  }

  task void stopDoneTask() {
    call SerialFlush.flush();
  }

  event void SerialFlush.flushDone(){
    call SerialControl.stop();
    signal SplitControl.stopDone(SUCCESS);
  }

  task void defaultSerialFlushTask(){
    signal SerialFlush.flushDone();
  }
  default command void SerialFlush.flush(){
    post defaultSerialFlushTask();
  }

  command error_t SplitControl.start() {
    post startDoneTask();
    return SUCCESS;
  }

  void testOff() {
    bool turnOff = FALSE;
    atomic {
      if (txState == TXSTATE_INACTIVE &&
	  rxState == RXSTATE_INACTIVE) {
	turnOff = TRUE;
      }
    }
    if (turnOff) {
      post stopDoneTask();
      atomic offPending = FALSE;
    }
    else {
      atomic offPending = TRUE;
    }
  }
    
  command error_t SplitControl.stop() {
    atomic {
      if (rxState == RXSTATE_NOSYNC) {
	rxState = RXSTATE_INACTIVE;
      }
    }
    atomic {
      if (txState == TXSTATE_IDLE) {
	txState = TXSTATE_INACTIVE;
      }
    }
    testOff();
    return SUCCESS;
  }

  /*
   *  Receive Path
   */ 
  
  
  async event void SerialFrameComm.delimiterReceived(){
    rx_state_machine(TRUE,0);
  }
  async event void SerialFrameComm.dataReceived(uint8_t data){
    rx_state_machine(FALSE,data);
  }

  /*
  bool valid_rx_proto(uint8_t proto) {
    switch (proto){
    case SERIAL_PROTO_PACKET_ACK: 
      return TRUE;
    case SERIAL_PROTO_ACK:
    case SERIAL_PROTO_PACKET_NOACK:
    default: 
      return FALSE;
    }
  }
  */

  void rx_state_machine(bool isDelimeter, uint8_t data){

    switch (rxState) {
      
    case RXSTATE_NOSYNC: 
      if (isDelimeter) {
        rxInit();
        rxState = RXSTATE_PROTO;
      }
      break;
      
    case RXSTATE_PROTO:  // MSB received, has to be = 0
      if (!isDelimeter){
        rxCRC = 0;          //rxCRC = crcByte(rxCRC,data);
        rxState = RXSTATE_TOKEN;
        rxProto = data;
        if(rxProto!=0)        //if (!valid_rx_proto(rxProto))
	    goto nosync;
        // only supports serial proto packet ack
	/*        if (rxProto != SERIAL_PROTO_PACKET_ACK){
          goto nosync;
	  }*/

        if (signal ReceiveBytePacket.startPacket() != SUCCESS){
          goto nosync;
        }
      }      
      break;
      
    case RXSTATE_TOKEN:  // LSB received = length
      if (isDelimeter) {
        goto nosync;
      }
      else {
        //rxSeqno = data;
	rxLen = data;
        //rxCRC = crcByte(rxCRC,rxSeqno);
        rxState = RXSTATE_API;

      }
      break;

    case RXSTATE_API:
      //if(data == 0x81) {    // need a valid_rx_api function in the future ...
	rxByteCnt++;
	rxCRC = rxCRC + data;
	rxState = RXSTATE_INFO;

	signal ReceiveBytePacket.byteReceived(data);
	//}
	/*else {
	goto nosync;
	}*/
      break;
      
    case RXSTATE_INFO:
      if (rxByteCnt < SERIAL_MTU) { 
        if (rxByteCnt == rxLen) { /* handle end of frame */
          if (data == (0xff - (rxCRC & 0xff))) { /* CRC check */

              signal ReceiveBytePacket.endPacket(SUCCESS);
              //ack_queue_push(rxSeqno);   // ACKs disabled
              goto nosync;
            }
          else {
            goto nosync;
          }
          
	}
        else { /* handle new bytes to save */
          //if (rxByteCnt >= 2){     // no need to lag 2 bytes behind since we know len in advance
            signal ReceiveBytePacket.byteReceived(data);
            rxCRC = rxCRC + data; //crcByte(rxCRC,rx_buffer_pop());
	    //}
	//rx_buffer_push(data);
          rxByteCnt++;
        }
      }
      
      /* no valid message.. */
      else {
        goto nosync;
       }
      break;
      
    default:      
      goto nosync;
    }
    goto done;

  nosync:
    /* reset all counters, etc */
    rxInit();
    call SerialFrameComm.resetReceive();
    signal ReceiveBytePacket.endPacket(FAIL);
    if (offPending) {
      rxState = RXSTATE_INACTIVE;
      testOff();
    }
    /* if this was a flag, start in proto state.. */
    else if (isDelimeter) {
      rxState = RXSTATE_PROTO;
    }
    
  done:
  }

  
  /*
   *  Send Path
   */ 


  void MaybeScheduleTx() {
    atomic {
      if (txPending == 0) {
        if (post RunTx() == SUCCESS) {
          txPending = 1;
        }
      }
    }
  }


  async command error_t SendBytePacket.completeSend(){
    bool ret = FAIL;
    atomic {
        txBuf[TX_DATA_INDEX].state = BUFFER_COMPLETE;
        ret = SUCCESS;
    }
    return ret;
  }

  async command error_t SendBytePacket.startSend(uint8_t b){
    bool not_busy = FALSE;
    atomic {
      if (txBuf[TX_DATA_INDEX].state == BUFFER_AVAILABLE){
        txBuf[TX_DATA_INDEX].state = BUFFER_FILLING;
        txBuf[TX_DATA_INDEX].buf = b;
        not_busy = TRUE;
      }
    }
    if (not_busy) {
      MaybeScheduleTx();
      return SUCCESS;
    }
    return EBUSY;

  }
  
  task void RunTx() {
    uint8_t idle;
    uint8_t done;
    uint8_t fail;
    
    /*
      the following trigger MaybeScheduleTx, which starts at most one RunTx:
      1) adding an ack to the ack queue (ack_queue_push())
      2) starting to send a packet (SendBytePacket.startSend())
      3) failure to send start delimiter in RunTx
      4) putDone: 
    */
    
    error_t result = SUCCESS;
    bool send_completed = FALSE;
    bool start_it = FALSE;
    
    atomic { 
      txPending = 0;
      idle = (txState == TXSTATE_IDLE);
      done = (txState == TXSTATE_FINISH);
      fail = (txState == TXSTATE_ERROR);
      if (done || fail){ 
        txState = TXSTATE_IDLE;
        txBuf[txIndex].state = BUFFER_AVAILABLE;
      }
    }
    
    /* if done, call the send done */
    if (done || fail) {
      txSeqno++;
      if (txProto == SERIAL_PROTO_ACK){
        ack_queue_pop();
      }
      else {
        result = done ? SUCCESS : FAIL;
        send_completed = TRUE;
      }
      idle = TRUE;
    }
    
    /* if idle, set up next packet to TX */ 
    if (idle) {
      bool goInactive;
      atomic goInactive = offPending;
      if (goInactive) {
        atomic txState = TXSTATE_INACTIVE;
      }
      else {
        /* acks are top priority */
        uint8_t myAckState;
        uint8_t myDataState;
        atomic {
          myAckState = txBuf[TX_ACK_INDEX].state;
          myDataState = txBuf[TX_DATA_INDEX].state;
        }
        if (!ack_queue_is_empty() && myAckState == BUFFER_AVAILABLE) {
          atomic {
            txBuf[TX_ACK_INDEX].state = BUFFER_COMPLETE;
            txBuf[TX_ACK_INDEX].buf = ack_queue_top();
          }
          txProto = SERIAL_PROTO_ACK;
          txIndex = TX_ACK_INDEX;
          start_it = TRUE;
        }
        else if (myDataState == BUFFER_FILLING || myDataState == BUFFER_COMPLETE){
          txProto = SERIAL_PROTO_PACKET_NOACK;
          txIndex = TX_DATA_INDEX;
          start_it = TRUE;
        }
        else {
          /* nothing to send now.. */
        }
      }
    }
    else {
      /* we're in the middle of transmitting */
    }
    
    if (send_completed){
      signal SendBytePacket.sendCompleted(result);
    }
    
    if (txState == TXSTATE_INACTIVE) {
      testOff();
      return;
    }
    
    if (start_it){
      /* OK, start transmitting ! */
      atomic { 
        txCRC = 0;
        txByteCnt = 0;
	//txState = TXSTATE_INFO; // ok if you write MSB in the dispatcher
        txState = TXSTATE_PROTO; // ok if you write MSB in this component
      }
      if (call SerialFrameComm.putDelimiter() != SUCCESS) {
        atomic txState = TXSTATE_ERROR; 
        MaybeScheduleTx();
      }
    }
    
  }
  
  async event void SerialFrameComm.putDone() {
    {
      error_t txResult = SUCCESS;
      
      switch (txState) {
        
      case TXSTATE_PROTO:

	//txResult = call SerialFrameComm.putData(txProto);
	txResult = call SerialFrameComm.putData(0); //put MSB = 0x00
#ifdef NO_TX_SEQNO
        txState = TXSTATE_INFO;
#else
        txState = TXSTATE_SEQNO;
#endif
        //txCRC = crcByte(txCRC,txProto);  // do not compute the CRC for MSB, start later
        break;
        
      case TXSTATE_SEQNO:
        txResult = call SerialFrameComm.putData(txSeqno);
        txState = TXSTATE_INFO;
        //txCRC = crcByte(txCRC,txSeqno);
        break;
        
      case TXSTATE_INFO:
        atomic {
          txResult = call SerialFrameComm.putData(txBuf[txIndex].buf);
	  if (txByteCnt > 0) { // if txByteCnt == 0, we are putting LSB, for which we do not compute CRC
	    //txCRC = crcByte(txCRC,txBuf[txIndex].buf);
	    txCRC = txCRC + txBuf[txIndex].buf;  // XBee CRC function
	  }
          ++txByteCnt;
          
          if (txIndex == TX_DATA_INDEX){
            uint8_t nextByte;
            nextByte = signal SendBytePacket.nextByte();
            if (txBuf[txIndex].state == BUFFER_COMPLETE || txByteCnt >= SERIAL_MTU){
              txState = TXSTATE_FCS1;
            }
            else { /* never called on ack b/c ack is BUFFER_COMPLETE initially */
              txBuf[txIndex].buf = nextByte;
            }
          }
          else { // TX_ACK_INDEX
            txState = TXSTATE_FCS1;
          }
        }
        break;
        
      case TXSTATE_FCS1:
	//txResult = call SerialFrameComm.putData(txCRC & 0xff);
	txResult = call SerialFrameComm.putData(0xff - (txCRC & 0xff)); // put the CRC at the end
        //txState = TXSTATE_FCS2;
	txState =  TXSTATE_ENDWAIT;
        break;
        /*
      case TXSTATE_FCS2:
        txResult = call SerialFrameComm.putData((txCRC >> 8) & 0xff);
        txState = TXSTATE_ENDFLAG;
        break;
        
      case TXSTATE_ENDFLAG:
        txResult = call SerialFrameComm.putDelimiter();
        txState = TXSTATE_ENDWAIT;
        break;
        */
      case TXSTATE_ENDWAIT:
        txState = TXSTATE_FINISH;
      case TXSTATE_FINISH:
        MaybeScheduleTx();
        break;
      case TXSTATE_ERROR:
      default:
        txResult = FAIL; 
        break;
      }
      
      if (txResult != SUCCESS) {
        txState = TXSTATE_ERROR;
        MaybeScheduleTx();
      }
    }
  }

  
 default event void SplitControl.startDone(error_t err) {}
 default event void SplitControl.stopDone(error_t err) {}
}
