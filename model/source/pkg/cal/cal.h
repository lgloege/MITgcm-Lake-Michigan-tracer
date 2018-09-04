C $Header: /u/gcmpack/MITgcm/pkg/cal/cal.h,v 1.3 2005/09/01 05:26:43 heimbach Exp $


c     ==================================================================
c     HEADER calendar
c     ==================================================================
c
c     o This header file contains variables that are used by the
c       calendar tool. The calendar tool can be used in the ECCO
c       SEALION release of the MITgcmUV.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu  17-Dec-1999
c              - restructured the original version in order to have a
c                better interface to the MITgcmUV.
c
c     ==================================================================
c     HEADER calendar
c     ==================================================================
c
c     - The calendar version:
c
      character*(5) calendarversion
      parameter(    calendarversion = '0.2.0' )

c     - Parameters of the numerical model:
c
c     modelstart       - start time of the numerical model.
c     modelstartdate   - start date of the numerical model.
c     modelend         - end   time of the numerical model.
c     modelenddate     - end   date of the numerical model.
c     modelstep        - timestep of the numerical model.
c     modelintsteps    - number of timestep that are to be performed.
c     modeliter0       - the numerical models initial timestep number.
c     modeliterend     - the models last timestep number.
c     modelstepsperday - number of model time steps per calendar day.
c
c
c     - Parameters used by the calendar:
c
c     refdate          - first day of the Gregorian Calendar.
c     nmonthyear       - number months in a year.
c     ndaymonth        - days per month depending on the year being a
c                        leap year or not. If the Gregorian calendar is
c                        not used a 360 days year with 30 days months is
c                        used instead.
c     ndaysnoleap      - number of days in a usual year.
c     ndaysleap        - number of days in a leap year.
c     nmaxdaymonth     - maximum number of days in a years month.
c     hoursperday      - number of hours   in a calendars day.
c     minutesperday    - number of minutes in a calendars day.
c     minutesperhour   - number of minutes in a calendars hour.
c     secondsperday    - number of seconds in a calendars day.
c     secondsperhour   - number of seconds in a calendars hour.
c     secondsperminute - number of seconds in a calendars minute.


      common /cal_rl/
     &                modelstart,
     &                modelend,
     &                modelstep

      _RL modelstart
      _RL modelend
      _RL modelstep

      common /cal_i/
     &               refdate,
     &               nmonthyear,
     &               ndaymonth,
     &               ndaysnoleap,
     &               ndaysleap,
     &               nmaxdaymonth,
     &               hoursperday,
     &               minutesperday,
     &               minutesperhour,
     &               secondsperday,
     &               secondsperhour,
     &               secondsperminute,
     &               modelstartdate,
     &               modelenddate,
     &               modeliter0,
     &               modeliterend,
     &               modelintsteps,
     &               modelstepsperday,
     &               startdate_1,
     &               startdate_2

      integer refdate(4)
      integer nmonthyear
      integer ndaymonth(12,2)
      integer ndaysnoleap
      integer ndaysleap
      integer nmaxdaymonth
      integer hoursperday
      integer minutesperday
      integer minutesperhour
      integer secondsperday
      integer secondsperhour
      integer secondsperminute

      integer modelstartdate(4)
      integer modelenddate(4)
      integer modeliter0
      integer modeliterend
      integer modelintsteps
      integer modelstepsperday

      integer startdate_1
      integer startdate_2


      common /cal_l/ 
     &               usingNoCalendar,
     &               usingModelCalendar,
     &               usingJulianCalendar,
     &               usingGregorianCalendar

      logical usingNoCalendar
      logical usingModelCalendar
      logical usingJulianCalendar
      logical usingGregorianCalendar


c     dayofweek   - Week day number one is the week day of refdate.
c                   For the Gregorian calendar this is Friday, 15-Oct-1582.
c
c     monthofyear - Both available calendars are assumed to have twelve
c                   months.

      common /calendar_ch/
     &                     dayofweek,
     &                     monthofyear

      character*(3) dayofweek(7)
      character*(3) monthofyear(12)



