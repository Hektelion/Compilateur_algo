CC=gcc
CFLAGS= -I./include
LDFLAGS= -lfl

EXECUTABLE=compilateur_algo

MKDIR = ./obj

FLEX_FILENAME = lexer
BISON_FILENAME = parser

OBJ_FILES = ./obj/$(FLEX_FILENAME).o ./obj/$(BISON_FILENAME).tab.o

TEST_FILES = $(wildcard ./algo/*.algo)
OUTPUT_FILES = $(patsubst ./algo/%.algo, ./output/%.output, $(TEST_FILES))

all : $(MKDIR) flex bison $(EXECUTABLE)

./obj :
	@mkdir $@

flex: ./flex/$(FLEX_FILENAME).l
	flex -o ./src/$(FLEX_FILENAME).c $<

bison : ./bison/$(BISON_FILENAME).y
	bison --debug -Wall -dv ./bison/$(BISON_FILENAME).y
	mv ./$(BISON_FILENAME).tab.h ./include
	mv ./$(BISON_FILENAME).tab.c ./src

exec_test : $(OUTPUT_FILES)

$(EXECUTABLE) : $(OBJ_FILES)
	$(CC) -o $(EXECUTABLE) $^ $(CFLAGS) $(LDFLAGS)
#./$(EXECUTABLE) < ./data/fichier.txt

./obj/%.o : ./src/%.c
	$(CC) -o $@ -c $< $(CFLAGS)

./output/%.output : ./algo/%.algo
	./$(EXECUTABLE) < $< $@

clean :
	@rm -vf ./obj/*.o
	@rm -vf ./src/$(FLEX_FILENAME).c
	@rm -vf ./src/$(BISON_FILENAME).tab.c
	@rm -vf ./include/$(BISON_FILENAME).tab.h
	@rm -vf ./$(EXECUTABLE)

print-% :
	@echo $* = $($*)

create_project :
	@mkdir ./src ./include ./obj