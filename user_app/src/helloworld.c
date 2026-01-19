#include"stdio.h"
#include"stdlib.h"
int main() {
   printf("Hello World,there is user app\n");
   printf("%d + %d = %d\n", 1, 2, 1 + 2);

   char s[]="Sample String";
   printf("String: %s\n", s);

   int *a=malloc(sizeof(int)*5);

   for (int i=0;i<5;i++) {
       a[i]=i*i;
   }
   printf("Array elements:\n");
   for (int i=0;i<5;i++) {
       printf("a[%d]=%d\n",i,a[i]);
   }

   return 0;
}