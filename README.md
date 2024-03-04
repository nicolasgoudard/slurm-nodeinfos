A function based on sinfo and squeue to display pretty nodes state

usage :
$ nodeinfos

NODELIST       CPU FREE_CPU     MEMORY FREE_MEMORY STATE        AVAIL_FEATURES             USERS          
---------- ------- -------- ---------- ----------- ------------ -------------------------- -----------------
armilia          8        8      22000       21833 idle         debian12,grrm,monoproc                    
brusel         112        0     255838      196879 alloc        debian12,grrm,g16          user1 user2 user3
calvani         32        0     255883      227996 alloc        debian12,grrm,g16,monoproc user1 user2  
muhka          112        0     255583      207189 alloc        debian12,grrm,g16          user1 user3  
mylos          192        0     515300      473410 alloc        sd,debian12,grrm,g16       user4         
pahry           12        0     159181      157738 alloc        debian12,grrm,monoproc     useer5      
plana          112        0     255369      207615 alloc        sd,debian12,grrm,g16       user1 user3 user4
samaris        128        0     255117      183247 alloc        sd,debian12,grrm,g16       user2 user3  
vista          128        0     255117      202490 alloc        sd,debian12,grrm,g16       user2 user3  
xhystos          8        8      14000       14111 idle         debian12,grrm,monoproc                    
---------- ------- -------- ---------- ----------- ------------ -------------------------- -----------------
TOTAL          844       16    2243388     1892508 NB NODES=10                                           
