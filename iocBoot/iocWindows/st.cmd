< envPaths
epicsEnvSet(STARTUP,$(TOP)/iocBoot/$(IOC))

dbLoadDatabase("../../dbd/mcaCanberra.dbd",0,0)
mcaCanberra_registerRecordDeviceDriver(pdbbase) 

errlogInit(20000)

var aimDebug 20

epicsEnvSet PREFIX 13LAB:

# AIMConfig(portName, ethernet_address, portNumber(1 or 2), maxChans,
#           maxSignals, maxSequences, ethernetDevice)
# On Windows the ethernetDevice name is unique to each network card.  
# The simplest way to get this name is to run this startup script with the string
# provided in the distribution.  This will fail, but the driver will then print
# out a list of all the valid network device names on your system, along with
# their descriptions.  Find the one that describes the network that your
# Canberra hardware is attached to, and replace the string in the AIMConfig
# commands below with that string.

# AIMConfig(portName, ethernet_address, portNumber(1 or 2), maxChans, 
#           maxSignals, maxSequences, ethernetDevice)
AIMConfig("AIM1/1", 0x3ED, 1, 2048, 1, 1, " \Device\NPF_{3BD8078E-A967-48D1-8B49-A21FA38B19F0}")
AIMConfig("AIM1/2", 0x3ED, 2, 2048, 8, 1, " \Device\NPF_{3BD8078E-A967-48D1-8B49-A21FA38B19F0}")
#AIMConfig("DSA2000", 0x8058, 1, 2048, 1, 1, "fei0")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=aim_adc1,DTYP=asynMCA,INP=@asyn(AIM1/1 0),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=aim_adc2,DTYP=asynMCA,INP=@asyn(AIM1/2 0),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=aim_adc3,DTYP=asynMCA,INP=@asyn(AIM1/2 2),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=aim_adc4,DTYP=asynMCA,INP=@asyn(AIM1/2 4),NCHAN=2048")
dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=aim_adc5,DTYP=asynMCA,INP=@asyn(AIM1/2 6),NCHAN=2048")
#dbLoadRecords("$(MCA)/mcaApp/Db/mca.db", "P=$(PREFIX),M=dsa2000_1,DTYP=asynMCA,INP=@asyn(DSA2000 0),NCHAN=2048")

icbShowModules

#icbConfig(portName, module, ethernetAddress, icbAddress, moduleType)
#   portName to give to this asyn port
#   ethernetAddress - Ethernet address of module, low order 16 bits
#   icbAddress - rotary switch setting inside ICB module
#   moduleType
#      0 = ADC
#      1 = Amplifier
#      2 = HVPS
#      3 = TCA
#      4 = DSP
icbConfig("icbAdc1", 0x3ED, 5, 0)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_adc.db", "P=$(PREFIX),ADC=adc1,PORT=icbAdc1")
icbConfig("icbAmp1", 0x3ED, 3, 1)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_amp.db", "P=$(PREFIX),AMP=amp1,PORT=icbAmp1")
icbConfig("icbHvps1", 0x3ED, 2, 2)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_hvps.db", "P=$(PREFIX),HVPS=hvps1,PORT=icbHvps1,LIMIT=6000")
icbConfig("icbTca1", 0x3ED, 8, 3)
dbLoadRecords("$(MCA)/mcaApp/Db/icb_tca.db", "P=$(PREFIX),TCA=tca1,MCA=aim_adc1,PORT=icbTca1")
#icbConfig("icbDsp1", 0x8058, 0, 4)
#dbLoadRecords("$(MCA)/mcaApp/Db/icbDsp.db", "P=$(PREFIX),DSP=dsp1,PORT=icbDsp1")


mcaAIMShowModules


#asynSetTraceMask "AIM1/1",0,0xff
#asynSetTraceMask "icbTca1",0,0x13
#asynSetTraceMask "icbHvps1",0,0xff

< save_restore.cmd

iocInit()

# save settings every thirty seconds
create_monitor_set("auto_settings.req",30,"P=$(PREFIX)")

