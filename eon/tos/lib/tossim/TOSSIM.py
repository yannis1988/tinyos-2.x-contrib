# This file was created automatically by SWIG.
# Don't modify this file, modify the SWIG interface instead.
# This file is compatible with both classic and new-style classes.

import _TOSSIM

def _swig_setattr(self,class_type,name,value):
    if (name == "this"):
        if isinstance(value, class_type):
            self.__dict__[name] = value.this
            if hasattr(value,"thisown"): self.__dict__["thisown"] = value.thisown
            del value.thisown
            return
    method = class_type.__swig_setmethods__.get(name,None)
    if method: return method(self,value)
    self.__dict__[name] = value

def _swig_getattr(self,class_type,name):
    method = class_type.__swig_getmethods__.get(name,None)
    if method: return method(self)
    raise AttributeError,name

import types
try:
    _object = types.ObjectType
    _newclass = 1
except AttributeError:
    class _object : pass
    _newclass = 0
del types


class MAC(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, MAC, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, MAC, name)
    def __repr__(self):
        return "<C MAC instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, MAC, 'this', _TOSSIM.new_MAC(*args))
        _swig_setattr(self, MAC, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_MAC):
        try:
            if self.thisown: destroy(self)
        except: pass
    def initHigh(*args): return _TOSSIM.MAC_initHigh(*args)
    def initLow(*args): return _TOSSIM.MAC_initLow(*args)
    def high(*args): return _TOSSIM.MAC_high(*args)
    def low(*args): return _TOSSIM.MAC_low(*args)
    def symbolsPerSec(*args): return _TOSSIM.MAC_symbolsPerSec(*args)
    def bitsPerSymbol(*args): return _TOSSIM.MAC_bitsPerSymbol(*args)
    def preambleLength(*args): return _TOSSIM.MAC_preambleLength(*args)
    def exponentBase(*args): return _TOSSIM.MAC_exponentBase(*args)
    def maxIterations(*args): return _TOSSIM.MAC_maxIterations(*args)
    def minFreeSamples(*args): return _TOSSIM.MAC_minFreeSamples(*args)
    def rxtxDelay(*args): return _TOSSIM.MAC_rxtxDelay(*args)
    def ackTime(*args): return _TOSSIM.MAC_ackTime(*args)
    def setInitHigh(*args): return _TOSSIM.MAC_setInitHigh(*args)
    def setInitLow(*args): return _TOSSIM.MAC_setInitLow(*args)
    def setHigh(*args): return _TOSSIM.MAC_setHigh(*args)
    def setLow(*args): return _TOSSIM.MAC_setLow(*args)
    def setSymbolsPerSec(*args): return _TOSSIM.MAC_setSymbolsPerSec(*args)
    def setBitsBerSymbol(*args): return _TOSSIM.MAC_setBitsBerSymbol(*args)
    def setPreambleLength(*args): return _TOSSIM.MAC_setPreambleLength(*args)
    def setExponentBase(*args): return _TOSSIM.MAC_setExponentBase(*args)
    def setMaxIterations(*args): return _TOSSIM.MAC_setMaxIterations(*args)
    def setMinFreeSamples(*args): return _TOSSIM.MAC_setMinFreeSamples(*args)
    def setRxtxDelay(*args): return _TOSSIM.MAC_setRxtxDelay(*args)
    def setAckTime(*args): return _TOSSIM.MAC_setAckTime(*args)

class MACPtr(MAC):
    def __init__(self, this):
        _swig_setattr(self, MAC, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, MAC, 'thisown', 0)
        _swig_setattr(self, MAC,self.__class__,MAC)
_TOSSIM.MAC_swigregister(MACPtr)

class Radio(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Radio, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Radio, name)
    def __repr__(self):
        return "<C Radio instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, Radio, 'this', _TOSSIM.new_Radio(*args))
        _swig_setattr(self, Radio, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_Radio):
        try:
            if self.thisown: destroy(self)
        except: pass
    def add(*args): return _TOSSIM.Radio_add(*args)
    def capacity(*args): return _TOSSIM.Radio_capacity(*args)
    def connected(*args): return _TOSSIM.Radio_connected(*args)
    def remove(*args): return _TOSSIM.Radio_remove(*args)

class RadioPtr(Radio):
    def __init__(self, this):
        _swig_setattr(self, Radio, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, Radio, 'thisown', 0)
        _swig_setattr(self, Radio,self.__class__,Radio)
_TOSSIM.Radio_swigregister(RadioPtr)

class Packet(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Packet, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Packet, name)
    def __repr__(self):
        return "<C Packet instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, Packet, 'this', _TOSSIM.new_Packet(*args))
        _swig_setattr(self, Packet, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_Packet):
        try:
            if self.thisown: destroy(self)
        except: pass
    def setSource(*args): return _TOSSIM.Packet_setSource(*args)
    def source(*args): return _TOSSIM.Packet_source(*args)
    def setDestination(*args): return _TOSSIM.Packet_setDestination(*args)
    def destination(*args): return _TOSSIM.Packet_destination(*args)
    def setLength(*args): return _TOSSIM.Packet_setLength(*args)
    def length(*args): return _TOSSIM.Packet_length(*args)
    def setType(*args): return _TOSSIM.Packet_setType(*args)
    def type(*args): return _TOSSIM.Packet_type(*args)
    def data(*args): return _TOSSIM.Packet_data(*args)
    def setData(*args): return _TOSSIM.Packet_setData(*args)
    def maxLength(*args): return _TOSSIM.Packet_maxLength(*args)
    def setStrength(*args): return _TOSSIM.Packet_setStrength(*args)
    def deliver(*args): return _TOSSIM.Packet_deliver(*args)
    def deliverNow(*args): return _TOSSIM.Packet_deliverNow(*args)

class PacketPtr(Packet):
    def __init__(self, this):
        _swig_setattr(self, Packet, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, Packet, 'thisown', 0)
        _swig_setattr(self, Packet,self.__class__,Packet)
_TOSSIM.Packet_swigregister(PacketPtr)

class EnergyMonitor(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, EnergyMonitor, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, EnergyMonitor, name)
    def __repr__(self):
        return "<C EnergyMonitor instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, EnergyMonitor, 'this', _TOSSIM.new_EnergyMonitor(*args))
        _swig_setattr(self, EnergyMonitor, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_EnergyMonitor):
        try:
            if self.thisown: destroy(self)
        except: pass
    def getEnergyStored(*args): return _TOSSIM.EnergyMonitor_getEnergyStored(*args)
    def getEnergyIn(*args): return _TOSSIM.EnergyMonitor_getEnergyIn(*args)
    def getEnergyOut(*args): return _TOSSIM.EnergyMonitor_getEnergyOut(*args)
    def getBatterySize(*args): return _TOSSIM.EnergyMonitor_getBatterySize(*args)
    def getWaste(*args): return _TOSSIM.EnergyMonitor_getWaste(*args)
    def setEnergyStored(*args): return _TOSSIM.EnergyMonitor_setEnergyStored(*args)
    def harvestEnergy(*args): return _TOSSIM.EnergyMonitor_harvestEnergy(*args)
    def consumeEnergy(*args): return _TOSSIM.EnergyMonitor_consumeEnergy(*args)
    def setBatterySize(*args): return _TOSSIM.EnergyMonitor_setBatterySize(*args)

class EnergyMonitorPtr(EnergyMonitor):
    def __init__(self, this):
        _swig_setattr(self, EnergyMonitor, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, EnergyMonitor, 'thisown', 0)
        _swig_setattr(self, EnergyMonitor,self.__class__,EnergyMonitor)
_TOSSIM.EnergyMonitor_swigregister(EnergyMonitorPtr)

class variable_string_t(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, variable_string_t, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, variable_string_t, name)
    def __repr__(self):
        return "<C variable_string_t instance at %s>" % (self.this,)
    __swig_setmethods__["type"] = _TOSSIM.variable_string_t_type_set
    __swig_getmethods__["type"] = _TOSSIM.variable_string_t_type_get
    if _newclass:type = property(_TOSSIM.variable_string_t_type_get, _TOSSIM.variable_string_t_type_set)
    __swig_setmethods__["ptr"] = _TOSSIM.variable_string_t_ptr_set
    __swig_getmethods__["ptr"] = _TOSSIM.variable_string_t_ptr_get
    if _newclass:ptr = property(_TOSSIM.variable_string_t_ptr_get, _TOSSIM.variable_string_t_ptr_set)
    __swig_setmethods__["len"] = _TOSSIM.variable_string_t_len_set
    __swig_getmethods__["len"] = _TOSSIM.variable_string_t_len_get
    if _newclass:len = property(_TOSSIM.variable_string_t_len_get, _TOSSIM.variable_string_t_len_set)
    __swig_setmethods__["isArray"] = _TOSSIM.variable_string_t_isArray_set
    __swig_getmethods__["isArray"] = _TOSSIM.variable_string_t_isArray_get
    if _newclass:isArray = property(_TOSSIM.variable_string_t_isArray_get, _TOSSIM.variable_string_t_isArray_set)
    def __init__(self, *args):
        _swig_setattr(self, variable_string_t, 'this', _TOSSIM.new_variable_string_t(*args))
        _swig_setattr(self, variable_string_t, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_variable_string_t):
        try:
            if self.thisown: destroy(self)
        except: pass

class variable_string_tPtr(variable_string_t):
    def __init__(self, this):
        _swig_setattr(self, variable_string_t, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, variable_string_t, 'thisown', 0)
        _swig_setattr(self, variable_string_t,self.__class__,variable_string_t)
_TOSSIM.variable_string_t_swigregister(variable_string_tPtr)

class nesc_app_t(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, nesc_app_t, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, nesc_app_t, name)
    def __repr__(self):
        return "<C nesc_app_t instance at %s>" % (self.this,)
    __swig_setmethods__["numVariables"] = _TOSSIM.nesc_app_t_numVariables_set
    __swig_getmethods__["numVariables"] = _TOSSIM.nesc_app_t_numVariables_get
    if _newclass:numVariables = property(_TOSSIM.nesc_app_t_numVariables_get, _TOSSIM.nesc_app_t_numVariables_set)
    __swig_setmethods__["variableNames"] = _TOSSIM.nesc_app_t_variableNames_set
    __swig_getmethods__["variableNames"] = _TOSSIM.nesc_app_t_variableNames_get
    if _newclass:variableNames = property(_TOSSIM.nesc_app_t_variableNames_get, _TOSSIM.nesc_app_t_variableNames_set)
    __swig_setmethods__["variableTypes"] = _TOSSIM.nesc_app_t_variableTypes_set
    __swig_getmethods__["variableTypes"] = _TOSSIM.nesc_app_t_variableTypes_get
    if _newclass:variableTypes = property(_TOSSIM.nesc_app_t_variableTypes_get, _TOSSIM.nesc_app_t_variableTypes_set)
    __swig_setmethods__["variableArray"] = _TOSSIM.nesc_app_t_variableArray_set
    __swig_getmethods__["variableArray"] = _TOSSIM.nesc_app_t_variableArray_get
    if _newclass:variableArray = property(_TOSSIM.nesc_app_t_variableArray_get, _TOSSIM.nesc_app_t_variableArray_set)
    def __init__(self, *args):
        _swig_setattr(self, nesc_app_t, 'this', _TOSSIM.new_nesc_app_t(*args))
        _swig_setattr(self, nesc_app_t, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_nesc_app_t):
        try:
            if self.thisown: destroy(self)
        except: pass

class nesc_app_tPtr(nesc_app_t):
    def __init__(self, this):
        _swig_setattr(self, nesc_app_t, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, nesc_app_t, 'thisown', 0)
        _swig_setattr(self, nesc_app_t,self.__class__,nesc_app_t)
_TOSSIM.nesc_app_t_swigregister(nesc_app_tPtr)

class Variable(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Variable, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Variable, name)
    def __repr__(self):
        return "<C Variable instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, Variable, 'this', _TOSSIM.new_Variable(*args))
        _swig_setattr(self, Variable, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_Variable):
        try:
            if self.thisown: destroy(self)
        except: pass
    def getData(*args): return _TOSSIM.Variable_getData(*args)

class VariablePtr(Variable):
    def __init__(self, this):
        _swig_setattr(self, Variable, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, Variable, 'thisown', 0)
        _swig_setattr(self, Variable,self.__class__,Variable)
_TOSSIM.Variable_swigregister(VariablePtr)

class Mote(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Mote, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Mote, name)
    def __repr__(self):
        return "<C Mote instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, Mote, 'this', _TOSSIM.new_Mote(*args))
        _swig_setattr(self, Mote, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_Mote):
        try:
            if self.thisown: destroy(self)
        except: pass
    def id(*args): return _TOSSIM.Mote_id(*args)
    def euid(*args): return _TOSSIM.Mote_euid(*args)
    def setEuid(*args): return _TOSSIM.Mote_setEuid(*args)
    def bootTime(*args): return _TOSSIM.Mote_bootTime(*args)
    def bootAtTime(*args): return _TOSSIM.Mote_bootAtTime(*args)
    def isOn(*args): return _TOSSIM.Mote_isOn(*args)
    def turnOff(*args): return _TOSSIM.Mote_turnOff(*args)
    def turnOn(*args): return _TOSSIM.Mote_turnOn(*args)
    def getVariable(*args): return _TOSSIM.Mote_getVariable(*args)
    def addNoiseTraceReading(*args): return _TOSSIM.Mote_addNoiseTraceReading(*args)
    def createNoiseModel(*args): return _TOSSIM.Mote_createNoiseModel(*args)
    def generateNoise(*args): return _TOSSIM.Mote_generateNoise(*args)
    def getEM(*args): return _TOSSIM.Mote_getEM(*args)

class MotePtr(Mote):
    def __init__(self, this):
        _swig_setattr(self, Mote, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, Mote, 'thisown', 0)
        _swig_setattr(self, Mote,self.__class__,Mote)
_TOSSIM.Mote_swigregister(MotePtr)

class Tossim(_object):
    __swig_setmethods__ = {}
    __setattr__ = lambda self, name, value: _swig_setattr(self, Tossim, name, value)
    __swig_getmethods__ = {}
    __getattr__ = lambda self, name: _swig_getattr(self, Tossim, name)
    def __repr__(self):
        return "<C Tossim instance at %s>" % (self.this,)
    def __init__(self, *args):
        _swig_setattr(self, Tossim, 'this', _TOSSIM.new_Tossim(*args))
        _swig_setattr(self, Tossim, 'thisown', 1)
    def __del__(self, destroy=_TOSSIM.delete_Tossim):
        try:
            if self.thisown: destroy(self)
        except: pass
    def init(*args): return _TOSSIM.Tossim_init(*args)
    def time(*args): return _TOSSIM.Tossim_time(*args)
    def ticksPerSecond(*args): return _TOSSIM.Tossim_ticksPerSecond(*args)
    def setTime(*args): return _TOSSIM.Tossim_setTime(*args)
    def timeStr(*args): return _TOSSIM.Tossim_timeStr(*args)
    def currentNode(*args): return _TOSSIM.Tossim_currentNode(*args)
    def getNode(*args): return _TOSSIM.Tossim_getNode(*args)
    def setCurrentNode(*args): return _TOSSIM.Tossim_setCurrentNode(*args)
    def addChannel(*args): return _TOSSIM.Tossim_addChannel(*args)
    def removeChannel(*args): return _TOSSIM.Tossim_removeChannel(*args)
    def randomSeed(*args): return _TOSSIM.Tossim_randomSeed(*args)
    def runNextEvent(*args): return _TOSSIM.Tossim_runNextEvent(*args)
    def mac(*args): return _TOSSIM.Tossim_mac(*args)
    def radio(*args): return _TOSSIM.Tossim_radio(*args)
    def newPacket(*args): return _TOSSIM.Tossim_newPacket(*args)

class TossimPtr(Tossim):
    def __init__(self, this):
        _swig_setattr(self, Tossim, 'this', this)
        if not hasattr(self,"thisown"): _swig_setattr(self, Tossim, 'thisown', 0)
        _swig_setattr(self, Tossim,self.__class__,Tossim)
_TOSSIM.Tossim_swigregister(TossimPtr)


