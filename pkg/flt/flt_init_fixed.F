#include "FLT_OPTIONS.h"

      SUBROUTINE FLT_INIT_FIXED( myThid  )

C     ==================================================================
C     SUBROUTINE FLT_INIT_FIXED
C     ==================================================================
C     o initializes Fixed array
C     ==================================================================

C     !USES:
      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#ifdef ALLOW_EXCH2
#include "W2_EXCH2_SIZE.h"
#include "W2_EXCH2_PARAMS.h"
#endif
#include "FLT_SIZE.h"
#include "FLT.h"

C     == routine arguments ==
C     myThid - thread number for this instance of the routine.
      INTEGER myThid

C     == local variables ==
      INTEGER bi, bj
      _RL xLo, xHi, yLo, yHi
      CHARACTER*(MAX_LEN_MBUF) msgBuf

C     == end of interface ==

C Set domain dependent constants:
      xLo = -xG( 1,  1,1,1)
      xHi = xG(sNx+1,1,1,1)
      yLo = -yG(1, 1,  1,1)
      yHi = yG(1,sNy+1,1,1)
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
         xLo = MAX( xLo, -xG(1,1,bi,bj) )
         xHi = MAX( xHi, xG(sNx+1,1,bi,bj) )
         yLo = MAX( yLo, -yG(1,1,bi,bj) )
         yHi = MAX( yHi, yG(1,sNy+1,bi,bj) )
       ENDDO
      ENDDO
      _GLOBAL_MAX_RL( xLo, myThid )
      _GLOBAL_MAX_RL( xHi, myThid )
      _GLOBAL_MAX_RL( yLo, myThid )
      _GLOBAL_MAX_RL( yHi, myThid )

      _BEGIN_MASTER(myThid)
       flt_xLo = -xLo
       flt_xHi =  xHi
       flt_yLo = -yLo
       flt_yHi =  yHi
       WRITE(msgBuf,'(A,2F18.8)')
     &    '  FLT_xLo,xHi=', xLo, xHi
         CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                       SQUEEZE_RIGHT, myThid )
         WRITE(msgBuf,'(A,2F18.8)')
     &    '  FLT_yLo,yHi=', yLo, yHi
         CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                       SQUEEZE_RIGHT, myThid )
      _END_MASTER(myThid)

#ifndef DEVEL_FLT_EXCH2
#ifdef ALLOW_EXCH2
        WRITE(msgBuf,'(2A)') 'FLT_INIT_FIXED:',
     &    ' exch2 is not yet fully supported in pkg/flt;'
        CALL PRINT_ERROR( msgBuf, myThid )
        WRITE(msgBuf,'(2A)') 'FLT_INIT_FIXED:',
     &    ' if you want to try using it anyway then recompile with'
        CALL PRINT_ERROR( msgBuf, myThid )
        WRITE(msgBuf,'(2A)') 'FLT_INIT_FIXED:',
     &    ' "#define DEVEL_FLT_EXCH2" added in FLT_OPTIONS.h'
        CALL PRINT_ERROR( msgBuf, myThid )
        STOP 'ABNORMAL END: S/R FLT_INIT_FIXED'
#endif
#endif

      RETURN
      END
