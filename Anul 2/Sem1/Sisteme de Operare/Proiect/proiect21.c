#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <time.h>

#define NR_DOCTORI 3
#define TIMP_GENERARE 30
#define INTERVAL_MINIM_PACIENTI 0
#define INTERVAL_MAXIM_PACIENTI 3
#define TIMP_MINIM_CONSULTATIE 4
#define TIMP_MAXIM_CONSULTATIE 9

sem_t doctori_disponibili;
pthread_mutex_t mutex_doctor[NR_DOCTORI];

void* pacient_routine(void* arg) {
    int id_pacient = *(int*)arg;
    free(arg);
    time_t timp_sosire = time(NULL);
    printf("Pacientul %d a sosit\n", id_pacient);
    sem_wait(&doctori_disponibili);
    for (int i = 1; i <= NR_DOCTORI; i++) {
        if (pthread_mutex_trylock(&mutex_doctor[i]) == 0) {
            printf("Pacientul %d a intrat la doctorul %d\n", id_pacient, i);
            time_t start_consultatie = time(NULL);
            int timp_asteptare = (int)(start_consultatie - timp_sosire);
            int timp_consultatie = rand() % (TIMP_MAXIM_CONSULTATIE - TIMP_MINIM_CONSULTATIE + 1) + TIMP_MINIM_CONSULTATIE;
            sleep(timp_consultatie);
            printf("Pacientul %d a iesit. Asteptare: %d secunde. Consultatie: %d secunde\n", id_pacient, timp_asteptare, timp_consultatie);
            pthread_mutex_unlock(&mutex_doctor[i]);
            sem_post(&doctori_disponibili);
            break;
        }
    }
    return NULL;
}

int main() {
    srand(time(NULL));
    sem_init(&doctori_disponibili, 0, NR_DOCTORI);
    for (int i = 1; i <= NR_DOCTORI; i++) {
        pthread_mutex_init(&mutex_doctor[i], NULL);
    }
    pthread_t threads[100];
    int nr_threads = 0;
    time_t start_time = time(NULL);
    while (time(NULL) - start_time < TIMP_GENERARE) {
        int* id_pacient = malloc(sizeof(int));
        *id_pacient = nr_threads + 1;
        pthread_create(&threads[nr_threads], NULL, pacient_routine, id_pacient);
        nr_threads++;
        sleep(rand() % (INTERVAL_MAXIM_PACIENTI - INTERVAL_MINIM_PACIENTI + 1) + INTERVAL_MINIM_PACIENTI);
    }
    for (int i = 0; i < nr_threads; i++) {
        pthread_join(threads[i], NULL);
    }
    sem_destroy(&doctori_disponibili);
    for (int i = 0; i < NR_DOCTORI; i++) {
        pthread_mutex_destroy(&mutex_doctor[i]);
    }
    return 0;
}
