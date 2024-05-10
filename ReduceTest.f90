program reduceTest
   implicit none
   include "mpif.h"
   integer rank, total, err

   integer, parameter :: tag = 0     ! tag for MPI messages (set to 0 and not used)
   integer :: message                ! the message

   integer :: send_buff(1), recv_buff(1)

   call MPI_INIT(err)


   call MPI_COMM_SIZE(MPI_COMM_WORLD, total, err)


   call MPI_COMM_RANK(MPI_COMM_WORLD, rank, err)


   send_buff = rank
   call MPI_REDUCE(send_buff, recv_buff, 1, MPI_INTEGER, MPI_SUM, 0, MPI_COMM_WORLD, err)

   print *, "Rank: ", rank, "recv: ", recv_buff

   call MPI_FINALIZE(err)

end program reduceTest
