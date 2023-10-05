#include <iostream>
#include <ctime>
using namespace std;

void printchess(int(&chest)[8][8]) {
	for (int i = 0; i < 8; ++i) {
		cout << "(";
		for (int j = 0; j < 8; ++j) {									
			cout << chest[i][j];
			if (j < 7) {
				cout << ",";
			}
		}
		cout << ")" << endl;
	}
}

void checkboardqueen(int(&chest)[8][8]) {	
	bool checkqueen = 1;
	int rownum = -1;
	int i = 0;
	int j = 0;

	//cout << "HORZIONTAL VIOLATION CHECK" << endl;
	for (int i = 0; i < 8; ++i) {	//row check that queen is placed in a horizontal unique row <->
		checkqueen = 0;
		// make a dymanic array
		int l = 0;
		int* jcollect = new int();
		for (int j = 0; j < 8; ++j) {
			if (chest[i][j] >= 1) {
				// store each J index in the array
				jcollect[l] = j;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				jcollect[l] = j;
				l++;
			}
		} // when loop finishes, check the if statement if checkqueen is 0


		// at the end of both for loops, add sizeofarray to each point on our chest board [same I][j]
		if (l > 1) {
			for (int k = 0; k < l; k++) {

				chest[i][jcollect[k]] += (l - 1);
			}

		}
	}




	int collumnum = -1;

	//cout << "Vertical VIOLATION CHECK" << endl;
	for (int j = 0; j < 8; j++) { //collum check that queen is placed in a unique vertical collum	
		checkqueen = 0;
		// make a dymanic array
		int l = 0;
		int* icollect = new int();
		for (int i = 0; i < 8; ++i) {
			if (chest[i][j] >= 1) {
				// store each I index in the array
				icollect[l] = i;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				icollect[l] = i;
				l++;
			}
		}
		// at the end of both for loops, add sizeofarray to each point on our chest board [same I][j]
		if (l > 1) {
			for (int k = 0; k < l; k++) {

				chest[icollect[k]][j] += (l - 1);
			}
		}
	}
	checkqueen = 0;


	// dianglal check from '\'
	i = 6;
	j = 0;
	int istore = i;
	int jstore = j;
	int switchbool = 0;

	//cout << "Left to Right Diagnal VIOLATION CHECK" << endl;

	for (int m = 0; m < 13; m++) {
		// make a dymanic array
		 int l = 0;
		 int* icollect = new int();
		 int* jcollect = new int();
		 // 
		while (i >= 0 && i < 8 && j >= 0 && j < 8 && switchbool == 0) {
			// check for down and to the right for a queen
			if (chest[i][j] >= 1) {
				// store each J index in the array
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
			}

			j++;
			i++;

		}
		if (switchbool == 0 && istore > 0) {
			istore--;
			i = istore;
			j = 0;
		}
		

		while (i >= 0 && i < 8 && j >= 0 && j < 8 && switchbool == 1) {
			// check for down and to the right for a queen
			if (chest[i][j] >= 1) {
				// store each J index in the array
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
			}
			j++;
			i++;
		}

		if (switchbool == 1) {
			i = 0;
			jstore++;
			j = jstore;
		}
        if (istore == 0) {
			switchbool = 1;
		}
		// at the end of both for loops, add sizeofarray to each point on our chest board [same I][same j]
		if (l > 1) {
			for (int k = 0; k < l; k++) {

				//cout << l << endl;
				//cout << k << endl;
				chest[icollect[k]][jcollect[k]] += (l - 1);
			}
		}
	}

	
	// dianglal check from '/'
	i = 6;
	j = 7;
	istore = i;
	jstore = j;
	switchbool = 0;

	//cout << "Right to Left Diagnal VIOLATION CHECK" << endl;

	for (int m = 0; m < 13; m++) {
		// make a dymanic array
		 int l = 0;
		 int* icollect = new int();
		 int* jcollect = new int();
		 // 
		while (i >= 0 && i < 8 && j >= 0 && j < 8 && switchbool == 0) {
			// check for down and to the left for a queen
			if (chest[i][j] >= 1) {
				// store each J index in the array
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
			}

			j--;
			i++;

		}
		if (switchbool == 0 && istore > 0) {
			istore--;
			i = istore;
			j = 7;
		}
		

		while (i >= 0 && i < 8 && j >= 0 && j < 8 && switchbool == 1) {
			// check for down and to the right for a queen
			if (chest[i][j] >= 1) {
				// store each J index in the array
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
				checkqueen = 1;
			}
			else if (checkqueen >= 1 && chest[i][j] >= 1) {
				jcollect[l] = j;
				// store each I index in the array
				icollect[l] = i;
				l++;
			}
			j--;
			i++;
		}

		if (switchbool == 1) {
			i = 0;
			jstore--;
			j = jstore;
		}
        if (istore == 0) {
			switchbool = 1;
		}
		// at the end of both for loops, add sizeofarray to each point on our chest board [same I][same j]
		if (l > 1) {
			for (int k = 0; k < l; k++) {

				chest[icollect[k]][jcollect[k]] += (l - 1);
			}
		}
	}

}

void placequeen(int(&chest)[8][8]) {
	// rule:the queen cannot be in another previous queen spot
	int collums = -1;	// X axis
	int rows = -1;	// Y Axis
	int i = 0;
	while (i < 8) {
		collums = rand() % (8); // randomize the placement in the X axis according to the size of the board
		rows = rand() % (8); // randomize the placement in the y axis according to the size of the board

		if (chest[rows][collums] == 1) {

		}
		else {
			chest[rows][collums] = 1;
			i++;
		}


	}

}

// Once we are done mutating then we reset all other violations not mutated to 1 so we know the queen still exist there.
void resetViolations(int(&chest)[8][8]){
    for (int i = 0; i < 8; ++i) {
		for (int j = 0; j < 8; ++j) {									
			if(chest[i][j] > 1){
			    chest[i][j] = 1;
			}
		}
	}
    
}

// The queens that are mutating will be randomly placed to other spots of the chest board.
void placeQueenByPoint(int(&chest)[8][8], int i, int j) {
	// rule:the queen cannot be in another previous queen spot
	int collums = -1;	// X axis
	int rows = -1;	// Y Axis
	
	collums = rand() % (8); // randomize the placement in the X axis according to the size of the board
	rows = rand() % (8); // randomize the placement in the y axis according to the size of the board

	while (chest[rows][collums] >= 1) {
        collums = rand() % (8); // randomize the placement in the X axis according to the size of the board
	    rows = rand() % (8); // randomize the placement in the y axis according to the size of the board
	}
	
	chest[rows][collums] = 1;


    chest[i][j] = 0;

}

int checkForMutation(int(&chest)[8][8]){
    int solution = 1;
    
    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            if (chest[i][j] > 3){
                placeQueenByPoint(chest, i, j);
                solution = 0;
            }
            else if(chest[i][j] < 4 && chest[i][j] > 1) {
                if ((rand() % (50)+1) == 50 ){
                    placeQueenByPoint(chest, i, j);
                    
                }
                solution = 0;
            }
        }
    }
    
    return solution;

}



void checkAndMutateUntilSolution(int(&chest)[8][8]){
    int solutionFound = 0;
    int counter = 0;
    while(solutionFound != 1){
        checkboardqueen(chest);
        solutionFound = checkForMutation(chest);
       // printchess(chest);
        resetViolations(chest);
       counter++;
    }
    cout << endl << endl << endl;
    cout << "The Amount of Times a incremental evolutions happened: " << counter << endl;
    //printchess(chest);
}

int main() {
	int chestboard[8][8] = { 0 };			// first [] is collums and second [] is rows
	srand(time(NULL));

	placequeen(chestboard);			//place queens in random locations
	//Initial Randomly Generated board
	std::cout << "Initially Generated Board:" << endl;
	printchess(chestboard);
	checkAndMutateUntilSolution(chestboard);
	printchess(chestboard);

}
