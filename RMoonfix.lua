script_name("RMoonfix")
----------------------------------------------
local ffi = require 'ffi'

ffi.cdef[[
   typedef short WORD;        

   typedef struct _SYSTEMTIME {
      WORD wYear;
      WORD wMonth;
      WORD wDayOfWeek;
      WORD wDay;
      WORD wHour;
      WORD wMinute;
      WORD wSecond;
      WORD wMilliseconds;
   } SYSTEMTIME;

   int __stdcall SetLocalTime(const SYSTEMTIME*);
   void __stdcall GetLocalTime(SYSTEMTIME*);
]]
local kernel32 = ffi.load('Kernel32.dll')

local fixed = false

local function setOnlyDate(year, month, day)
   local date = ffi.new('SYSTEMTIME')
   kernel32.GetLocalTime(date)
   date.wYear = year
   date.wMonth = month
   date.wDay = day
   kernel32.SetLocalTime(date)
end

local function getOnlyDate()
   local date = ffi.new('SYSTEMTIME')
   kernel32.GetLocalTime(date)
   return date.wYear, date.wMonth, date.wDay
end

function main()

   fixed = true
      printStringNow('Fixing, wait!', 2500)

      local saved_year, saved_month, saved_day

      saved_year, saved_month, saved_day = getOnlyDate()
      setOnlyDate(2021, 09, 27)
      wait(1000)
      setOnlyDate(saved_year, saved_month, saved_day)

      saved_year, saved_month, saved_day = getOnlyDate()
      setOnlyDate(2021, 09, 29)
      wait(6000)
      setOnlyDate(saved_year, saved_month, saved_day)

      printStringNow('Moonloader fixed! <3', 2500)

   wait(-1)
end