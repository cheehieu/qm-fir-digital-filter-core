import serial,time,array, math, os, datetime
from Numeric import *
ser = serial.Serial('/dev/ttyS0', 57600)

dbg = True

def printDbg(str):
  if (dbg):
    print str

def sendCmd(cmd):
  byte1 = 0xff & (cmd >> 8)
  byte2 = 0xff & (cmd)
  bytes = chr(byte1)+chr(byte2)
#  printDbg ("Sending command 0x%04x" % (cmd))
  ser.write(bytes)

def sendData(data):
  byte1 = 0xff & (data >> 24)
  byte2 = 0xff & (data >> 16)     
  byte3 = 0xff & (data >> 8)      
  byte4 = 0xff & (data)           
  bytes = chr(byte1)+chr(byte2)+chr(byte3)+chr(byte4)
#  print ("Sending data 0x%08x" % (data))
  ser.write(bytes)

def rdData():
#  time.sleep(.1)
#  print ("Pre InWaiting=%d" % ser.inWaiting())
  tmp = ser.read(4)
#  print ("Post InWaiting=%d" % ser.inWaiting())
  result = (ord(tmp[0]) << 24) + (ord(tmp[1]) << 16) + (ord(tmp[2]) << 8) + ord(tmp[3])
#  print ("Read data: 0x%08x" % (result))
  return result

def wrMem(addr,data):
  cmd  = 0xC000 | (0x3FFF & addr)
  data = 0xffffffff & data
  print ("Writing 0x%08x to location 0x%08x" % (data, 0x3fff & addr))
  sendCmd(cmd)
  sendData(data)

def wrReg(addr,data):
  cmd  = 0x8000 | (0xf & addr)
  data = 0xffffffff & data
#  print ("Writing 0x%08x to reg %d" % (data, 0xf & addr))
  sendCmd(cmd)
  sendData(data)

def rdMem(addr):
  cmd  = 0x4000 | (0x3FFF & addr)
#  print ("Reading from location 0x%04x" % (0x3fff & addr))
  sendCmd(cmd)
  return rdData()

def rdReg(addr):
  cmd  = 0x0000 | (0xf & addr)
#  print ("Reading from reg %d" % (0xf & addr))
  sendCmd(cmd)
  return rdData()

def rdState():
  return ((rdReg(1) & 0x00C000) >> 14)

def wrState(st):
  wrReg(1, 0x400000 | ((st << 14) & 0x00C000))



def tohex(h,i):
  value = (h[i]<<31)+(h[i+1] <<30)+(h[i+2] <<29)+(h[i+3] <<28)+(h[i+4] <<27)+(h[i+5] <<26)+(h[i+6] <<25)+(h[i+7] <<24)+(h[i+8] <<23)+(h[i+9] <<22)+(h[i+10]<<21)+(h[i+11]<<20)+(h[i+12]<<19)+(h[i+13]<<18)+(h[i+14]<<17)+(h[i+15]<<16)+(h[i+16]<<15)+(h[i+17]<<14)+(h[i+18]<<13)+(h[i+19]<<12)+(h[i+20]<<11)+(h[i+21]<<10)+(h[i+22]<<9)+(h[i+23]<<8)+(h[i+24]<<7)+(h[i+25]<<6)+(h[i+26]<<5)+(h[i+27]<<4)+(h[i+28]<<3)+(h[i+29]<<2)+(h[i+30]<<1)+(h[i+31])
  return value

def todec(data, p1):
  if (p1 == 1):
    data1 = -((data>>15)%2)*pow(2,1)+((data>>14)%2)*pow(2,0)+((data>>13)%2)*pow(2,-1)+((data>>12)%2)*pow(2,-2)+((data>>11)%2)*pow(2,-3)+((data>>10)%2)*pow(2,-4)+((data>>9)%2)*pow(2,-5)+((data>>8)%2)*pow(2,-6)+((data>>7)%2)*pow(2,-7)+((data>>6)%2)*pow(2,-8)+((data>>5)%2)*pow(2,-9)+((data>>4)%2)*pow(2,-10)+((data>>3)%2)*pow(2,-11)+((data>>2)%2)*pow(2,-12)+((data>>1)%2)*pow(2,-13)+((data>>0)%2)*pow(2,-14)
  elif (p1 == 0):
    data1 = ((data>>15)%2)*pow(2,1)+((data>>14)%2)*pow(2,0)+((data>>13)%2)*pow(2,-1)+((data>>12)%2)*pow(2,-2)+((data>>11)%2)*pow(2,-3)+((data>>10)%2)*pow(2,-4)+((data>>9)%2)*pow(2,-5)+((data>>8)%2)*pow(2,-6)+((data>>7)%2)*pow(2,-7)+((data>>6)%2)*pow(2,-8)+((data>>5)%2)*pow(2,-9)+((data>>4)%2)*pow(2,-10)+((data>>3)%2)*pow(2,-11)+((data>>2)%2)*pow(2,-12)+((data>>1)%2)*pow(2,-13)+((data>>0)%2)*pow(2,-14)
  else:
    print "error"
  return data1

def todec_whole(data):
  data1 = ((data>>7)%2)*pow(2,7)+((data>>6)%2)*pow(2,6)+((data>>5)%2)*pow(2,5)+((data>>4)%2)*pow(2,4)+((data>>3)%2)*pow(2,3)+((data>>2)%2)*pow(2,2)+((data>>1)%2)*pow(2,1)+((data>>0)%2)*pow(2,0)
  return data1
