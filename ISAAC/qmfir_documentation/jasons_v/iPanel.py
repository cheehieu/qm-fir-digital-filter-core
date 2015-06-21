import os
import pprint
import random
import sys
import wx
from wx import py
from demo_ser2 import *
from threading import *
import time

import sys
import serial,time,array, math, datetime
from Numeric import *
ser = serial.Serial('/dev/ttyS0', 57600)
#ser = serial.Serial(port='/dev/ttyUSB0', baudrate=57600)


import __main__

import matplotlib
matplotlib.use('WXAgg')
from matplotlib.figure import Figure
from matplotlib.backends.backend_wxagg import \
    FigureCanvasWxAgg as FigCanvas, \
    NavigationToolbar2WxAgg as NavigationToolbar
import numpy as np
import pylab


ID_CUT  = wx.NewId()
ID_COPY = wx.NewId()
ID_PASTE= wx.NewId()
ID_ABOUT= wx.NewId()
ID_HELP = wx.NewId()
EVT_RESULT_ID = wx.NewId()
EVT_WRITE_ID = wx.NewId()

def EVT_RESULT(win, func):
    """Define Result Event."""
    win.Connect(-1, -1, EVT_RESULT_ID, func)

def EVT_WRITE(win, func):
    win.Connect(-1, -1, EVT_WRITE_ID, func)

class ResultEvent(wx.PyEvent):
    """Simple event to carry arbitrary result data."""
    def __init__(self, data):
        """Init Result Event."""
        wx.PyEvent.__init__(self)
        self.SetEventType(EVT_RESULT_ID)
        self.data = data

class WriteEvent(wx.PyEvent):
    def  __init__(self, msg):
        """Init Result Event."""
        wx.PyEvent.__init__(self)
        self.SetEventType(EVT_WRITE_ID)
        self.msg = msg

# Thread class that executes processing
class WorkerThread(Thread):
    """Worker Thread Class."""
    def __init__(self, notify_window):
        """Init Worker Thread Class."""
        Thread.__init__(self)
        self.setDaemon(True)
        self._notify_window = notify_window
        self._want_abort = 0
        self.start()

    def run(self):
        """Run Worker Thread."""


        #######################################
        ########## TRANSFER PROTOCOL  #########
        #######################################

        ser.inWaiting()
        ser.flushInput()
        ser.flushInput()
        ser.flushInput()
        ser.flushInput()
        ser.flushOutput()
        ser.flushOutput()
        ser.flushOutput()
        ser.inWaiting()
        k=0
        old_freq=(eval(frame.freqBox.GetValue()))
        print "old frequency = %d" %(old_freq)
        while 1:
            new_freq=(eval(frame.freqBox.GetValue()))
            print "new frequency = %d" % (new_freq)
            if new_freq != old_freq:
                print " new frequency"
                k=0
            if k==0:
                print "---Generating new data file---"
                wx.PostEvent(self._notify_window, WriteEvent("\n\n       Cycle " + str(k)+"\n"))
                wx.PostEvent(self._notify_window, WriteEvent( "---Generating new data file---"+"\n"))
                f1 = open("ssi_ms6_240_freq.txt","w")
                print >> f1, """ f_noi=%d
ssi_ms6_240_freq
exit""" % (new_freq)
                f1.close()
                os.system("/usr/local/bin/matlab -nodesktop -nosplash -r rotate=%d <ssi_ms6_240_freq.txt" % (k*1600))
                old_freq = ((eval(frame.freqBox.GetValue())))
                print "old frequency = %d" % (old_freq)
            
           
            k=k+1
            q = k-1
            if k != 1:
                wx.PostEvent(self._notify_window, WriteEvent("\n\n       Cycle " + str(q)+"\n"))
            print """\n\n---Grabbing New Data File---"""
            wx.PostEvent(self._notify_window, WriteEvent("""---Grabbing New Data File---"""+"\n"))
            print "before grabbing data"
            new = os.path.getmtime("xov_bi.txt")  #Timestamp

            if k!=1 :     #First time don't check for the timestamp
                newfile = new==old
                while newfile==True:
                    new = os.path.getmtime("xov_bi.txt")
                    newfile = new==old
                    print "waiting"
                    wx.PostEvent(self._notify_window, WriteEvent("waiting"+"\n"))
                    time.sleep(1)
            print "after checking timestamp"

            f = open("xov_bi.txt","rb")
            A = f.read()
            f.close()
            n = size(A)
            h=zeros(n)
            old = os.path.getmtime("xov_bi.txt")

            path = ""
            filehandle_p11_expected = open(os.path.join(path, "xbsr3_c1_expected.txt"), 'r')
            self.data_p11_expected1 = eval(filehandle_p11_expected.read())
            filehandle_p11_expected.close()

            filehandle_p21_expected = open(os.path.join(path, "xbsr3_c2_expected.txt"), 'r')
            self.data_p21_expected1 = eval(filehandle_p21_expected.read())
            filehandle_p21_expected.close()

            filehandle_p31_expected = open(os.path.join(path, "xbsr3_c3_expected.txt"), 'r')
            self.data_p31_expected1 = eval(filehandle_p31_expected.read())
            filehandle_p31_expected.close()

            filehandle_p12_expected = open(os.path.join(path, "xbsi3_c1_expected.txt"), 'r')
            self.data_p12_expected1 = eval(filehandle_p12_expected.read())
            filehandle_p12_expected.close()

            filehandle_p22_expected = open(os.path.join(path, "xbsi3_c2_expected.txt"), 'r')
            self.data_p22_expected1 = eval(filehandle_p22_expected.read())
            filehandle_p22_expected.close()

            filehandle_p32_expected = open(os.path.join(path, "xbsi3_c3_expected.txt"), 'r')
            self.data_p32_expected1 = eval(filehandle_p32_expected.read())
            filehandle_p32_expected.close()

            filehandle_p00 = open(os.path.join(path,"xov.txt"), 'r')
            self.data_p00_1 = eval(filehandle_p00.read())
            filehandle_p00.close()
            print "done reading expected data k=%d" % (k-1)

            child_pid = os.fork()
            if child_pid:   # PARENT EXECUTING
            #Reading in the file and changing it to binary
                i=0
                j=0
                while  (i < n):
                    if (A[i] == '0'):
                        h[j] = 0
                        i = i + 1
                        j=j+1
                    elif (A[i] == '1'):
                        h[j] = 1
                        i = i + 1
                        j=j+1
                    else:
                        i = i + 1

                #Changing the binary to hex
                b=zeros(2701,Float)
                i=0
                j=0
                while (j < 2701):
                    b[j] = tohex(h[0:size(h)],i)
                    i=i+32
                    j=j+1

                #Reset the core to sync with the incoming phase
                print """---Reset the Core to Sync the Phase---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reset the Core to Sync the Phase---"""+"\n"))
                wrReg(1,0x8001)
                wrReg(1,0x0001)
                wrReg(2,0x0000)
                wrReg(3,0x0000)
                wrReg(5,0x0000)
                wrReg(6,0x0000)


                #Start the data transfer
                print """---Transfering Data to Board---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Transfering Data to Board---"""+"\n"))
                i=0
                while (i < 2701):
                    wrMem(i,int(b[i]))
                    time.sleep(.001)
                    i = i + 1

                #Start the corecalculation of the new frequency, could be different each time
                wrReg(4,old_freq+128)  # frequency
                wrReg(4,0x4000)    # Start calculation of frequency coefficients
                data=rdReg(4)
                data1 = todec_whole(data)
                wx.PostEvent(self._notify_window, WriteEvent("""    Reading FPGA Frequency Register\n"""))
                if k == 1:
                    wx.PostEvent(self._notify_window, WriteEvent("""  ******************************\n"""))
                    wx.PostEvent(self._notify_window, WriteEvent("""  |       Filter Frequency is: """ + str(data1) + "        |" +"\n"))
                    wx.PostEvent(self._notify_window, WriteEvent("""  ******************************\n"""))
                else:
                    wx.PostEvent(self._notify_window, WriteEvent("""       FPGA Frequency is: """ + str(data1) + "        " +"\n"))
                print ("    Reg 4 Read data: %d" % (data1)) 
                wrReg(4,0x0000)  # Deassert

                #Starting the core
                print """---Starting Filter Process---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Starting to Filter Process---"""+"\n"))
                wrReg(1,0x8008)  # START THE CORE


                #Reading the processed data
                print """---Reading Band 1 Real Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Band 1 Real Data---"""+"\n"))
                #read R1
                f1 = open("xbsr3_c1.txt","w")
                print >> f1, '[',
                i=0
                while (i < 82):
                    data = rdMem(2048+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e , ' % (data1),
                    i = i + 1
                print >> f1, ']',
                f1.close()

                print """---Reading Band 1 Imaginary Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Band 1 Imaginary Data---"""+"\n"))
                #read I1
                f1 = open("xbsi3_c1.txt","w")
                print >> f1, '[',
                i=0
                while (i < 82):
                    data = rdMem(20480+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e ,' % (data1),
                    i=i+1
                print >> f1, ']',
                f1.close()

                print """---Reading Noise Real Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Noise Real Data---"""+"\n"))
                #read R2
                f1 = open("xbsr3_c2.txt","w")
                print >> f1, '[',
                i=0
                while (i < 82):
                    data = rdMem(22528+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e ,' % (data1),
                    i=i+1
                print >> f1, ']',
                f1.close()

                print """---Reading Noise Imaginary Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Noise Imaginary Data---"""+"\n"))
                #read I2
                f1 = open("xbsi3_c2.txt","w")
                i=0
                print >> f1, '[',
                while (i < 82):
                    data = rdMem(24576+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e, ' % (data1),
                    i=i+1
                print >> f1, ']',
                f1.close()

                print """---Reading Band 2 Real Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Band 2 Real Data---"""+"\n"))
                #read R3
                f1 = open("xbsr3_c3.txt","w")
                print >> f1, '[',
                i=0
                while (i < 82):
                    data = rdMem(26624+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e  ,' % (data1),
                    i=i+1
                print >> f1, ']',
                f1.close()

                print """---Reading Band 2 Imaginary Data---"""
                wx.PostEvent(self._notify_window, WriteEvent("""---Reading Band 2 Imaginary Data---"""+"\n"))
                #read I3
                f1 = open("xbsi3_c3.txt","w")
                i=0
                print >> f1, '[',
                while (i < 82):
                    data = rdMem(28672+i)
                    p1 = (data >> 15)%2
                    data1 = todec(data,p1)
                    print >> f1, '%e  ,' % (data1),
                    i=i+1
                print >> f1, ']',
                f1.close()

                path = ""
                print "i am here"
                filehandle_p11 = open(os.path.join(path, "xbsr3_c1.txt"), 'r')
                self.data_p11 = eval(filehandle_p11.read())
                filehandle_p11.close()

                filehandle_p21 = open(os.path.join(path, "xbsr3_c2.txt"), 'r')
                self.data_p21 = eval(filehandle_p21.read())
                filehandle_p21.close()

                filehandle_p31 = open(os.path.join(path, "xbsr3_c3.txt"), 'r')
                self.data_p31 = eval(filehandle_p31.read())
                filehandle_p31.close()

                filehandle_p12 = open(os.path.join(path, "xbsi3_c1.txt"), 'r')
                self.data_p12 = eval(filehandle_p12.read())
                filehandle_p12.close()

                filehandle_p22 = open(os.path.join(path, "xbsi3_c2.txt"), 'r')
                self.data_p22 = eval(filehandle_p22.read())
                filehandle_p22.close()

                filehandle_p32 = open(os.path.join(path, "xbsi3_c3.txt"), 'r')
                self.data_p32 = eval(filehandle_p32.read())
                filehandle_p32.close()

                self.data_p11_expected = list(self.data_p11_expected1)
                self.data_p21_expected = list(self.data_p21_expected1)
                self.data_p31_expected = list(self.data_p31_expected1)
                self.data_p12_expected = list(self.data_p12_expected1) 
                self.data_p22_expected = list(self.data_p22_expected1) 
                self.data_p32_expected = list(self.data_p32_expected1) 
                self.data_p00 = list(self.data_p00_1)

                print "done reading board data %d" % (k-1)

            else:   # CHILD EXECUTING
                f1 = open("ssi_ms6_240_freq_re.txt","w")
                print >> f1, """ f_noi=%d
ssi_ms6_240_freq_re
exit""" % (eval(frame.freqBox.GetValue()))
                f1.close()
                if k != 0:
                    print "   ---Generating new data file ---"
                    os.system("/usr/local/bin/matlab -nodesktop -nosplash -r rotate=%d <ssi_ms6_240_freq_re.txt" % ((k)*1600))    
                    print "done with matlab k=%d" % (k)
                    old_freq = ((eval(frame.freqBox.GetValue())))
                    print "old frequency = %d"%(old_freq)
                os._exit(0)
                 
   
            if self._want_abort:
                wx.PostEvent(self._notify_window, ResultEvent(None))
                return
            wx.PostEvent(self._notify_window, ResultEvent(1))

            print "k = %d" % (k)
      
        wx.PostEvent(self._notify_window, ResultEvent(None))
        frame.paused = True


    def abort(self):
        """abort worker thread."""
        self._want_abort = 1

class MainWindow(wx.Frame):
    def __init__(self, parent, id, title):
        wx.Frame.__init__(self, parent, wx.ID_ANY, title, size=(800,700))
        dbg = True
    

        
#########Menu setup############
        
        #Prepares menu bar
        self.menuBar = wx.MenuBar()
        self.CreateStatusBar()
        
        #file menu set up
        filemenu = wx.Menu()
        NEW = wx.MenuItem(filemenu, 101, "&New \tCtrl+N", "Start new session")
        filemenu.AppendItem(NEW)
        OPEN = wx.Menu()
        OPEN.Append(501, "Plot All")
        OPEN.Append(502, "Plot Sequentially")
        OPEN.Append(503, "Auto Mode")
        filemenu.AppendMenu(102, "&Open", OPEN)
        self.SAVE= wx.MenuItem(filemenu, 103, "&Save\tCtrl+S", "Save a file")
        self.SAVE.Enable(False)
        filemenu.AppendItem(self.SAVE)
        SAVEAS= wx.MenuItem(filemenu, 104, "Save As...", "Save as...")
        filemenu.AppendItem(SAVEAS)
        filemenu.AppendSeparator()
        QUIT= wx.MenuItem(filemenu, 105, "&Quit\tCtrl+Q", "Terminate the program")
        filemenu.AppendItem(QUIT)
        self.menuBar.Append(filemenu, "&File") #creating the menu bar
        self.Bind(wx.EVT_MENU, self.OnNew, id=101)
        self.Bind(wx.EVT_MENU, self.OnPlotAll, id=501)
        self.Bind(wx.EVT_MENU, self.OnPlotSeq, id=502)
        self.Bind(wx.EVT_MENU, self.OnAutoMode, id=503)
        self.Bind(wx.EVT_MENU, self.OnSave, id=103)
        self.Bind(wx.EVT_MENU, self.OnSaveAs, id=104)
        self.Bind(wx.EVT_MENU, self.OnQuit, id=105)

        #edit menu set up
        self.editmenu = wx.Menu()
        self.editmenu.Append(ID_CUT, "&Cut", "Cut")
        self.editmenu.Append(ID_COPY, "C&opy", "Copy")
        self.editmenu.Append(ID_PASTE, "&Paste", "Paste")
        self.menuBar.Append(self.editmenu, "&Edit")
        #edit menu event
        wx.EVT_MENU(self, ID_CUT, self.OnCut)
        wx.EVT_MENU(self, ID_COPY, self.OnCopy)
        wx.EVT_MENU(self, ID_PASTE, self.OnPaste)
        
        #instrument menu set up
        instmenu = wx.Menu()
        ADD = wx.MenuItem(instmenu, 301, "Add\tCtrl+A", "Add an instrument")
        instmenu.AppendItem(ADD)
        self.READ = wx.MenuItem(instmenu, 302, "Read", "Read data from instrument")
        self.READ.Enable(False)
        instmenu.AppendItem(self.READ)
        self.SEND = wx.MenuItem(instmenu, 303, "Send", "Send data to instrument")
        self.SEND.Enable(False)
        instmenu.AppendItem(self.SEND)
        instmenu.AppendSeparator()
        CLEAR = wx.MenuItem(instmenu, 304, "Clear", "Clear Instrument Status Box")
        instmenu.AppendItem(CLEAR)
        self.menuBar.Append(instmenu, "&Instrument")
        #inst menu event
        self.Bind(wx.EVT_MENU, self.OnAdd, id=301)
        self.Bind(wx.EVT_MENU, self.OnRead, id=302)
        self.Bind(wx.EVT_MENU, self.OnSend, id=303)
        self.Bind(wx.EVT_MENU, self.OnClear, id=304)        
        
        #help menu
        helpmenu = wx.Menu()
        helpmenu.Append(ID_ABOUT, "About"," Information about this program")
        helpmenu.AppendSeparator()
        helpmenu.Append(ID_HELP, "Help on iPanel", "Help files for iPanel")
        self.menuBar.Append(helpmenu, "&Help")
        
        #help menu event
        wx.EVT_MENU(self, ID_ABOUT, self.OnAbout)
        wx.EVT_MENU(self, ID_HELP, self.OnHelp)
        
        self.SetMenuBar(self.menuBar)

#########################Layout###################################
        panel = wx.Panel(self, -1, style=wx.BORDER_SUNKEN)
        self.Maximize()
        panel.SetBackgroundColour('WHITE')


        
        hbox = wx.BoxSizer(wx.HORIZONTAL)

### Left Side###
        vbox1 = wx.BoxSizer(wx.VERTICAL)
        
        
        panel1 = wx.Panel(panel, -1)
# panel 11
        panel11 = wx.Panel(panel1, -1, size=(-1, 40))
        panel11.SetBackgroundColour('WHITE') #sets bg to blue
        hbox11 = wx.BoxSizer(wx.HORIZONTAL)
        sizer11 = wx.StaticBoxSizer(wx.StaticBox(panel11, -1, ' ISAAC iPanel v 1.0 (c) 2009'), orient=wx.HORIZONTAL)
        self.logo = wx.BitmapButton(panel11, -1, wx.Bitmap("logo2.jpg"))
        sizer11.Add(self.logo)
        self.instInfo = "SMAP Digital Filter Demo Control Panel \n" +\
            "GR-PCI-XC2V Prototype Board \n" +\
            "Xilinx XC2V3000-4FG676 FPGA \n" +\
            "Demo Date: April 7, 2009"
        
        sizer12 = wx.StaticBoxSizer(wx.StaticBox(panel11, -1, ' Instrument Information'), orient=wx.VERTICAL)
        self.info_box = wx.TextCtrl(panel11, -1, self.instInfo, style=wx.TE_NO_VSCROLL | wx.TE_READONLY | wx.TE_MULTILINE | wx.TE_CENTER)
        font=wx.Font(11, wx.SWISS, wx.NORMAL, wx.BOLD)
        self.info_box.SetFont(font)
 
        
        sizer12.Add(self.info_box, 1, wx.EXPAND)
        hbox11.Add(sizer11, 0, wx.EXPAND | wx.ALL, 5)
        hbox11.Add(sizer12, 1, wx.EXPAND | wx.ALL, 5)
        panel11.SetSizer(hbox11)
          
# panel 12
        self.panel12 = wx.Panel(panel1, -1, style=wx.BORDER_SUNKEN)
        self.panel12.SetBackgroundColour('WHITE')
        self.hbox12 = wx.BoxSizer(wx.HORIZONTAL)

        self.paused = True #starts out paused
        self.create_main_panel()

        
        vbox1.Add(panel11, 0, wx.EXPAND)
        vbox1.Add(self.panel12, 1, wx.EXPAND)

        panel1.SetSizer(vbox1)

###Right Side###

        vbox2 = wx.BoxSizer(wx.VERTICAL)
        panel2 = wx.Panel(panel, -1)

        self.instStatus = ">> "
        sizer21 = wx.StaticBoxSizer(wx.StaticBox(panel2, -1, ' Instrument Status'), orient=wx.VERTICAL)
        self.status_box = wx.TextCtrl(panel2, -1, self.instStatus, style= wx.TE_READONLY | wx.TE_MULTILINE)
        self.clr_button = wx.Button(panel2, -1, "Clear")
        self.Bind(wx.EVT_BUTTON, self.on_clr_button, self.clr_button)
        sizer21.Add(self.status_box, 1, wx.EXPAND)
        sizer21.Add(self.clr_button, 0, wx.ALIGN_RIGHT)
        vbox2.Add(sizer21, 1, wx.EXPAND | wx.ALL, 2)
        vbox2.Add((-1,10))
        panel2.SetSizer(vbox2)

        hbox.Add(panel1, 8, wx.EXPAND | wx.RIGHT)
        hbox.Add(panel2, 2, wx.EXPAND)
        panel.SetSizer(hbox)
        
        self.Centre()
        self.Show(True)
        
#######function definitions################
        
    def OnNew(self, event):
        """new session"""
        dCopy=wx.MessageDialog( self, "Does not work in this version",  "New", wx.CANCEL | wx.ICON_EXCLAMATION)
        dCopy.ShowModal()
        dCopy.Destroy()
        
    def OnPlotAll(self, event):
        """Plots all at once"""
        self.dirname = ''
        dOpen = wx.FileDialog(self, "Choose a file", self.dirname, "","*.*", wx.OPEN)
        if dOpen.ShowModal() == wx.ID_OK:
            self.filename=dOpen.GetFilename()
            self.dirname=dOpen.GetDirectory()
            filehandle=open(os.path.join(self.dirname, self.filename), 'r')
            self.data = eval(filehandle.read()) #eval converts from string back to list
            
            filehandle.close()

            self.SetTitle("Editing ..."+self.filename)
            
        dOpen.Destroy()
        
    def OnPlotSeq(self, event):
        """Plots Sequentially"""
        self.dirname = ''
        dOpen = wx.FileDialog(self, "Choose a file", self.dirname, "","*.*", wx.OPEN)
        if dOpen.ShowModal() == wx.ID_OK:
            self.filename=dOpen.GetFilename()
            self.dirname=dOpen.GetDirectory()

            filehandle=open(os.path.join(self.dirname, self.filename), 'r')
            self.read_data = eval(filehandle.read()) #eval converts from string back to list
            
            filehandle.close()

            self.SetTitle("Editing ..."+self.filename)
            self.fileOpen = True
            if self.fileOpen == True: #if a file is opened
                self.dataread = DataRead(self.read_data) #declares an instance self.dataread with class DataRead()
                self.data = [self.dataread.next()]
            else:
                return
        
        dOpen.Destroy()

    def OnPlotAll(self, event):
        """Open a file"""

        self.dirname = ''
        dOpen = wx.FileDialog(self, "Choose a file", self.dirname, "","*.*", wx.OPEN)
        if dOpen.ShowModal() == wx.ID_OK:
            self.filename=dOpen.GetFilename()
            self.dirname=dOpen.GetDirectory()

            filehandle=open(os.path.join(self.dirname, self.filename), 'r')
            self.data = eval(filehandle.read()) #eval converts from string back to list
            
            filehandle.close()

            self.SetTitle("Editing ..."+self.filename)
            
        dOpen.Destroy()
        
    def OnAutoMode(self, event):
        """automatically detects presence of files to be loaded, specifically for SMAP demo"""
        dAutoMode = wx.DirDialog(self, "Choose a directory:",
                          style=wx.DD_DEFAULT_STYLE
                           )

        if dAutoMode.ShowModal() == wx.ID_OK:
            path = dAutoMode.GetPath()

            filehandle_p11 = open(os.path.join(path, "xbsr3_c1.txt"), 'r')
            self.data_p11 = filehandle_p11
            filehandle_p11.close()

            filehandle_p21 = open(os.path.join(path, "xbsr3_c2.txt"), 'r')
            self.data_p21 = filehandle_p21
            filehandle_p21.close()

            filehandle_p31 = open(os.path.join(path, "xbsr3_c3.txt"), 'r')
            self.data_p31 = filehandle_p31
            filehandle_p31.close()

            filehandle_p12 = open(os.path.join(path, "xbsi3_c2.txt"), 'r')
            self.data_p12 = filehandle_p12
            filehandle_p12.close()

            filehandle_p22 = open(os.path.join(path, "xbsi3_c2.txt"), 'r')
            self.data_p22 = filehandle_p22
            filehandle_p22.close()

            filehandle_p32 = open(os.path.join(path, "xbsi3_c3.txt"), 'r')
            self.data_p32 = filehandle_p32
            filehandle_p32.close()
        # Only destroy a dialog after you're done with it.
        dAutoMode.Destroy()

    def OnSave(self, event):
        """Save a file"""
        if self.filename != None:
            self.saveContents()
            
    def OnSaveAs(self, event):
        """Save As"""
            
        self.dirname = ''
        dSave=wx.FileDialog(self, "Save file as ...", defaultDir=self.dirname, defaultFile=self.instName, style=wx.SAVE | wx.OVERWRITE_PROMPT)

        if dSave.ShowModal() == wx.ID_OK:
            self.filename = dSave.GetFilename()
            self.dirname = dSave.GetDirectory()
            self.saveContents()

        dSave.Destroy
        
    def OnQuit(self, event):
        self.Close(True)
        

    def OnCut(self, event):
        """Cut"""
        dCut=wx.MessageDialog(self, "Does not work in this version",  "Cut", wx.CANCEL | wx.ICON_EXCLAMATION)
        dCut.ShowModal()
        dCut.Destroy()
        
    def OnCopy(self, event):
        """Copy"""
        dCopy=wx.MessageDialog(self, "Does not work in this version",  "Copy", wx.CANCEL | wx.ICON_EXCLAMATION)
        dCopy.ShowModal()
        dCopy.Destroy()
        
    def OnPaste(self, event):
        """Paste"""
        dPaste=wx.MessageDialog(self, "Does not work in this version", "Paste", wx.CANCEL | wx.ICON_EXCLAMATION)
        dPaste.ShowModal()
        dPaste.Destroy()
    
    def OnAdd(self, event):
        dlg = wx.TextEntryDialog(self, 'Name', 'Instrument Entry')

        dlg.SetValue("")

        if dlg.ShowModal() == wx.ID_OK:
            self.info_box.Clear()
            self.instName = dlg.GetValue()
            self.info_box.write("Instrument Name: "+self.instName + "\n")
            self.READ.Enable(True)
            self.SEND.Enable(True)
        dlg.Destroy()
        
    def OnRead(self, event):
        """Read"""
        dPaste=wx.MessageDialog(self, "Does not work in this version", "Paste", wx.CANCEL | wx.ICON_EXCLAMATION)
        dPaste.ShowModal()
        dPaste.Destroy()
        
    def OnSend(self, event):
        """Send"""
        dPaste=wx.MessageDialog(self, "Does not work in this version", "Paste", wx.CANCEL | wx.ICON_EXCLAMATION)
        dPaste.ShowModal()
        dPaste.Destroy()
        
    def OnClear(self, event):
        self.instName = ""
        self.info_box.Clear()
        self.READ.Enable(False)
        self.SEND.Enable(False)
        
    def OnAbout(self, event):
        msg = " ISAAC iPanel Interface Beta ver. 1.0 \n\n" +\
              " (C) 2009 Jason S. Chu 2009       JPL NASA  \n\n"
             
        dAbout=wx.MessageDialog(self, msg, "About iPanel", wx.OK | wx.ICON_INFORMATION)
        dAbout.ShowModal()
        dAbout.Destroy() #destroy when finished
        
    def OnHelp(self, event):
        msg = " No help files have been added"
        dAbout=wx.MessageDialog(self, msg, "Help Files", wx.OK | wx.ICON_INFORMATION)
        dAbout.ShowModal()
        dAbout.Destroy() #destroy when finished
        
    def create_main_panel(self):
        self.dpi =75
        self.fig = Figure(figsize=None, dpi=self.dpi)

        
        self.axes_p00 = self.fig.add_subplot(6,1,1)
        self.axes_p11 = self.fig.add_subplot(6,3,7)
        self.axes_p21 = self.fig.add_subplot(6,3,8)
        self.axes_p31 = self.fig.add_subplot(6,3,9)
        self.axes_p12 = self.fig.add_subplot(6,3,10)
        self.axes_p22 = self.fig.add_subplot(6,3,11)
        self.axes_p32 = self.fig.add_subplot(6,3,12)
        self.axes_p13 = self.fig.add_subplot(6,3,13)
        self.axes_p23 = self.fig.add_subplot(6,3,14)
        self.axes_p33 = self.fig.add_subplot(6,3,15)
        self.axes_p14 = self.fig.add_subplot(6,3,16)
        self.axes_p24 = self.fig.add_subplot(6,3,17)
        self.axes_p34 = self.fig.add_subplot(6,3,18)
        

        pylab.setp(self.axes_p11.set_ylabel("Real"), fontsize=14)
        pylab.setp(self.axes_p12.set_ylabel("Imaginary"), fontsize=14) 
        pylab.setp(self.axes_p13.set_ylabel("Diff RE"), fontsize=14)
        pylab.setp(self.axes_p14.set_ylabel("Diff IM"), fontsize=14)

        pylab.setp(self.axes_p11.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p11.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p21.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p21.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p31.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p31.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p12.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p12.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p22.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p22.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p32.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p32.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p13.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p13.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p23.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p23.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p33.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p33.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p14.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p14.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p24.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p24.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p34.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p34.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p00.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p00.get_yticklabels(), fontsize=9)


        
        self.canvas = FigCanvas(self.panel12, -1, self.fig) #creates canvas for graph

        self.axes_p11.set_title('Ch 1', size=20)
        self.axes_p21.set_title('Noise', size=20)
        self.axes_p31.set_title('Ch 2', size=20)
        self.axes_p00.set_title('Input Data', size=20)
        
        self.pause_button = wx.Button(self.panel12, -1, "Pause")
        self.Bind(wx.EVT_BUTTON, self.on_pause_button, self.pause_button)
        self.Bind(wx.EVT_UPDATE_UI, self.on_update_pause_button, self.pause_button)

        EVT_RESULT(self,self.OnResult)
        EVT_WRITE(self, self.OnWrite)

        self.worker = None

        self.console_button = wx.Button(self.panel12, -1, "Console")
        self.Bind(wx.EVT_BUTTON, self.on_console_button, self.console_button)
        labelText = wx.StaticText(self.panel12,-1, "Frequency (MHz):")
        self.freq = "65"
        self.freqBox=wx.TextCtrl(self.panel12,-1,self.freq,size=(25,-1))
        self.sizer12 = wx.StaticBoxSizer(wx.StaticBox(self.panel12, -1, 'Telemetry'), orient=wx.VERTICAL)
        self.sizer12.Add(self.canvas, 1, wx.EXPAND)
        

        buttonBox12 = wx.StaticBoxSizer(wx.StaticBox(self.panel12, -1, 'Controls'), orient=wx.HORIZONTAL)
        buttonBox12.Add(self.pause_button, 0)
        buttonBox12.Add((20, -1))   #spacers
        buttonBox12.Add(self.console_button, 0)
        buttonBox12.Add((20, -1))   #spacers
        buttonBox12.Add(labelText,0)

        buttonBox12.Add((20,-1))
        buttonBox12.Add(self.freqBox,0)
        buttonBox12.Add((20,-1))
                                 
        self.sizer12.Add(buttonBox12, 0, wx.EXPAND)
        self.hbox12.Add(self.sizer12, 1, wx.EXPAND | wx.ALL, 5)
        self.panel12.SetSizer(self.hbox12)
                                 
    def init_plot(self):
        def diff(data1, data2):
            i=0
            data_diff=[]
            try:
                while i < len(data1):
                    data_diff.append(abs(data1[i]- data2[i]))
                    i = i + 1
            except IndexError:
                while i < len(data2):
                    data_diff.append(abs(data1[i]- data2[i]))
                    i = i + 1

            return data_diff

        print "start..."
        self.data_p11_expected = list(self.worker.data_p11_expected)
        self.data_p21_expected = list(self.worker.data_p21_expected)
        self.data_p31_expected = list(self.worker.data_p31_expected)
        self.data_p12_expected = list(self.worker.data_p12_expected)
        self.data_p22_expected = list(self.worker.data_p22_expected)
        self.data_p32_expected = list(self.worker.data_p32_expected)
        self.data_p11 = list(self.worker.data_p11)
        self.data_p21 = list(self.worker.data_p21)
        self.data_p31 = list(self.worker.data_p31)
        self.data_p12 = list(self.worker.data_p12)
        self.data_p22 = list(self.worker.data_p22)
        self.data_p32 = list(self.worker.data_p32)
        self.data_p00 = list(self.worker.data_p00)
        print "stop..."

        self.data_p13 = diff(self.data_p11, self.data_p11_expected)
        self.data_p23 = diff(self.data_p21, self.data_p21_expected)
        self.data_p33 = diff(self.data_p31, self.data_p31_expected)
        self.data_p14 = diff(self.data_p12, self.data_p12_expected)
        self.data_p24 = diff(self.data_p22, self.data_p22_expected)
        self.data_p34 = diff(self.data_p32, self.data_p32_expected)

        self.fig.delaxes(self.axes_p11)
        self.fig.delaxes(self.axes_p21)
        self.fig.delaxes(self.axes_p31)
        self.fig.delaxes(self.axes_p12)
        self.fig.delaxes(self.axes_p22)
        self.fig.delaxes(self.axes_p32)
        self.fig.delaxes(self.axes_p13)
        self.fig.delaxes(self.axes_p23)
        self.fig.delaxes(self.axes_p33)
        self.fig.delaxes(self.axes_p14)
        self.fig.delaxes(self.axes_p24)
        self.fig.delaxes(self.axes_p34)
        self.fig.delaxes(self.axes_p00)
        
        self.axes_p00 = self.fig.add_subplot(6,1,1)
        self.axes_p11 = self.fig.add_subplot(6,3,7)
        self.axes_p21 = self.fig.add_subplot(6,3,8)
        self.axes_p31 = self.fig.add_subplot(6,3,9)
        self.axes_p12 = self.fig.add_subplot(6,3,10)
        self.axes_p22 = self.fig.add_subplot(6,3,11)
        self.axes_p32 = self.fig.add_subplot(6,3,12)
        self.axes_p13 = self.fig.add_subplot(6,3,13)
        self.axes_p23 = self.fig.add_subplot(6,3,14)
        self.axes_p33 = self.fig.add_subplot(6,3,15)
        self.axes_p14 = self.fig.add_subplot(6,3,16)
        self.axes_p24 = self.fig.add_subplot(6,3,17)
        self.axes_p34 = self.fig.add_subplot(6,3,18)

        self.axes_p11.set_title('Ch 1', size=20)
        self.axes_p21.set_title('Noise', size=20)
        self.axes_p31.set_title('Ch 2', size=20)
        self.axes_p00.set_title('Input Data', size=20)
        
        pylab.setp(self.axes_p11.set_ylabel("Real"), fontsize=14)
        pylab.setp(self.axes_p12.set_ylabel("Imaginary"), fontsize=14) 
        pylab.setp(self.axes_p13.set_ylabel("Diff RE"), fontsize=14)
        pylab.setp(self.axes_p14.set_ylabel("Diff IM"), fontsize=14)
        
        pylab.setp(self.axes_p11.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p11.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p21.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p21.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p31.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p31.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p12.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p12.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p22.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p22.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p32.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p32.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p13.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p13.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p23.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p23.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p33.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p33.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p14.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p14.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p24.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p24.get_yticklabels(), fontsize=9)
        pylab.setp(self.axes_p34.get_xticklabels(), fontsize=9)
        pylab.setp(self.axes_p34.get_yticklabels(), fontsize=9)
        
        self.plot_data_p11 = self.axes_p11.plot(self.data_p11, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p11_expected = self.axes_p11.plot(self.data_p11_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p21 = self.axes_p21.plot(self.data_p21, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p21_expected = self.axes_p21.plot(self.data_p21_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p31 = self.axes_p31.plot(self.data_p31, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p31_expected = self.axes_p31.plot(self.data_p31_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p12 = self.axes_p12.plot(self.data_p12, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p12_expected = self.axes_p12.plot(self.data_p12_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p22 = self.axes_p22.plot(self.data_p22, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p22_expected = self.axes_p22.plot(self.data_p22_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p32 = self.axes_p32.plot(self.data_p32, linewidth=1, color=(1, 0, 0))[0]
        self.plot_data_p32_expected = self.axes_p32.plot(self.data_p32_expected, linewidth=1, color=(0, 0, 1))[0]
        self.plot_data_p13 = self.axes_p13.plot(self.data_p13, linewidth=1, color=(1, 0, 1))[0]
        self.plot_data_p23 = self.axes_p23.plot(self.data_p23, linewidth=1, color=(1, 0, 1))[0]
        self.plot_data_p33 = self.axes_p33.plot(self.data_p33, linewidth=1, color=(1, 0, 1))[0]
        self.plot_data_p14 = self.axes_p14.plot(self.data_p14, linewidth=1, color=(1, 0, 1))[0]
        self.plot_data_p24 = self.axes_p24.plot(self.data_p24, linewidth=1, color=(1, 0, 1))[0]
        self.plot_data_p34 = self.axes_p34.plot(self.data_p34, linewidth=1, color=(1, 0, 1))[0]       
        self.plot_data_p00 = self.axes_p00.plot(self.data_p00, linewidth=1, color=(0, 0, 1))[0]


    def on_clr_button(self, event):
        self.status_box.Clear()
        self.status_box.write(">> ")

    def on_pause_button(self, event):
        if self.label == "Stop":
            self.paused = True
            self.status_box.write("""Trying to abort..."""+"\n\n")
            self.worker.abort()
        elif self.label == "Start":
            self.paused = False
            self.status_box.write("""Starting..."""+"\n")
            self.worker = WorkerThread(self)
        
    def OnResult(self, event):
        """Show Result status."""
        self.init_plot()
        print "start drawing..."
        self.canvas.draw()
        print "stop drawing..."
        
        if event.data is None:
            self.status_box.write("""Transfer stopped"""+"\n")
            self.status_box.write("\n"+"\n"+">> ")
            self.worker = None
   
    def OnWrite(self, event):
        self.status_box.write(event.msg)

    def on_update_pause_button(self, event):
        self.label = "Start" if self.paused else "Stop"
        self.pause_button.SetLabel(self.label)

    def OnInit(self):
        confDir = wx.StandardPaths.Get().GetUserDataDir()
        if not os.path.exists(confDir):
            os.mkdir(confDir)
        fileName = os.path.join(confDir, 'config')
        self.config = wx.FileConfig(localFilename=fileName)
        self.config.SetRecordDefaults(True)

        self.frame = py.shell.ShellFrame(config=self.config, dataDir=confDir)
        self.frame.Show()
        return True
    def on_console_button(self, event):
        self.OnInit()

        
if __name__== "__main__":    
    app = wx.PySimpleApp()
    frame=MainWindow(None, -1, 'iPanel - SMAP')
    app.MainLoop()
