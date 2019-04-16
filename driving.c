#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

float total = 0.0;
pthread_mutex_t m1 = PTHREAD_MUTEX_INITIALIZER;

void *miles(void* par){
	char *cpar = (char*) par;
	int miles = atoi(cpar);
	pthread_mutex_lock(&m1);
	total = miles*(.58)*9;
	printf("The total for this trip is: %.2f\n",total);		
	pthread_mutex_unlock(&m1);
	return NULL;
}

int main(int argc, char **argv){
	pthread_t tid[argc];
	for(int i =0; i<argc-1;i++){
		pthread_create(&tid[i],NULL, (void*)miles, argv[i+1]);	
	}
	for(int i = 0; i<argc-1;i++){
		pthread_join(tid[i],NULL);
	}
	pthread_exit(0);
}

