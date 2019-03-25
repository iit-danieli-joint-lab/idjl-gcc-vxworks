#ifndef IDJL_CUSTOM_SYS_TIME_H
#define IDJL_CUSTOM_SYS_TIME_H

// Custom header to define gettimeofday, that is available in VxWorks 6.9, but was not 
// available in VxWorks 6.3, the version for which public headers are available 
// Definition from http://pubs.opengroup.org/onlinepubs/009695399/functions/gettimeofday.html

struct timeval; 

int gettimeofday(struct timeval *restrict tp, void *restrict tzp); 

#endif
