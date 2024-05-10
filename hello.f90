! start of program
program hello

   ! prevent typographical errors from declaring new variables
   implicit none

   ! include the MPI Fortran headers
   include "mpif.h"

   ! declare variables
   integer rank    ! value corresponding to this MPI process
   integer total   ! total number of MPI processes
   integer err     ! error code returned by MPI calls (not checked)

   character(len=1024) :: filename

   ! initialise the MPI implementation
   call MPI_INIT(err)

   ! determine the size of the MPI_COMM_WORLD communicator
   call MPI_COMM_SIZE(MPI_COMM_WORLD, total, err)

   ! determine the rank of this MPI process in the MPI_COMM_WORLD communicator
   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, err)

   write (filename, "(A8,I0.3,A4)") "HelloOut", rank, ".txt"
   open(unit = 2, file = filename)
   ! print rank and size to standard output
   write(2,*) "Hello world from process ", rank, " of ", total, "!"

   ! finalise the MPI implementation
   call MPI_FINALIZE(err)

! end of program
end

function itoa(i) result(res)
   character(:),allocatable :: res
   integer,intent(in) :: i
   character(range(i)+2) :: tmp
   write(tmp,'(i0)') i
   res = trim(tmp)
end function
