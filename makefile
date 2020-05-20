CC=gcc
CFLAGS= -I./include
LDFLAGS= -lfl

EXECUTABLE=executable_test

MKDIR = ./obj

SRC_FILES = $(wildcard ./src/*.c)
OBJ_FILES = $(patsubst ./src/%.c, ./obj/%.o, $(SRC_FILES))

all : clean $(MKDIR) flex $(EXECUTABLE)

./obj :
	@mkdir $@

flex : ./flex/compilateur.l
	flex -o ./src/compilateur.c $<

$(EXECUTABLE) : $(OBJ_FILES)
	$(CC) -o $(EXECUTABLE) $^ $(CFLAGS) $(LDFLAGS)
#./$(EXECUTABLE) < ./data/fichier.txt

./obj/%.o : ./src/%.c ./include/constant.h
	$(CC) -o $@ -c $< $(CFLAGS)

clean :
	@rm -f ./obj/*.o
	@rm -f ./$(EXECUTABLE)