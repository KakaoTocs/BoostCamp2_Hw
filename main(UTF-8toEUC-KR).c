#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <wchar.h>

int main()
{
    setlocale(LC_ALL, "en_US.UTF-8");

    FILE *fileOriginal, *fileClone;

    fileOriginal=fopen("D:\\Code\\C\\BoostCamp\\students.json", "r");
    fileClone = fopen("D:\\Code\\C\\BoostCamp\\students(euc-kr).json", "w");

    if(fileOriginal == NULL) {
        printf("fileOriginal Open Error!");
    }

    else {
        wint_t text;
        text = fgetwc(fileOriginal);
        while(text != WEOF)
        {
            printf("%c", text);
            fprintf(fileClone, "%c", text);
            text = fgetwc(fileOriginal);
        }
    }

    fclose(fileOriginal);
    fclose(fileClone);

    return 0;
}
