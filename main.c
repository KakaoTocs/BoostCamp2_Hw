#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <wchar.h>

int main()
{
    setlocale(LC_ALL, "en_US.UTF-8");

    FILE *fileA, *fileB;
    wint_t tempA, tempB;
    int byteCounter = 1, errorCounter = 0;

    fileA=fopen("C:\\resultAnswer.txt", "r");
    fileB=fopen("C:\\result.txt", "r");

    if(fileA == NULL) {
        printf("fileA Open Error!");
    } else if(fileB == NULL) {
        printf("fileB Open Error!");
    }

    else {
        tempA=fgetwc(fileA);
        tempB=fgetwc(fileB);

        while(tempA != WEOF || tempB != WEOF)
        {
            if(tempA == tempB)
                printf("Equal! %3d\n", tempA);
            else {
                printf("Not Equal!\nA:%3d  B:%3d\n", tempA, tempB);
                errorCounter++;
            }
            tempA=fgetwc(fileA);
            tempB=fgetwc(fileB);
            byteCounter++;
        }
        printf("%dbyte\n", byteCounter-1);
        printf("Different Char: %d", errorCounter);
    }

    fclose(fileA);
    fclose(fileB);

    return 0;
}
