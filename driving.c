#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

float total = 0.0;
pthread_mutex_t m1 = PTHREAD_MUTEX_INITIALIZER;
int trips =0.0;
float rate = 0.0;
void *miles(void* par){
	char *cpar = (char*) par;
	float miles = atof(cpar);
	pthread_mutex_lock(&m1);
	total = miles*(rate)*trips;
	printf("The total for this trip is: %.2f\n",total);		
	pthread_mutex_unlock(&m1);
	return NULL;
}

int main(int argc, char **argv){
	if(argc <3){
		printf("Please pass the following: ./driving <Number of trips> <The rate of reimbursement> <Number of Miles>\n");
		return 0;
	}
	pthread_t tid[argc-1];
	trips = atoi(argv[1]);
	rate  = atof(argv[2]);
	for(int i =0; i<argc-3;i++){
		pthread_create(&tid[i],NULL, (void*)miles, argv[i+3]);	
	}
	for(int i = 0; i<argc-3;i++){
		pthread_join(tid[i],NULL);
	}
	pthread_exit(0);
}

