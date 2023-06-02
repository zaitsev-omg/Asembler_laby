#include <iostream>

using namespace std;

extern "C" int first_row_sum(int*, int);
extern "C" int first_col_sum(int*, int);
extern "C" void arr_change(int*, int);

int main()
{
	setlocale(LC_ALL, "ru");
	int n;
	//entering the dimensions of the matrix
	cout << "Enter the size of the square matrix: "; cin >> n;
	//memory allocation for matrices
	int* matrix = new int[n * n];
	//entering the matrix
	cout << "Entering the matrix" << endl;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
		{
			cin >> matrix[i * n + j];
		}
	//matrix output
	cout << "Initial matrix:" << endl;
	for (int i = 0; i < n; cout << endl, i++)
		for (int j = 0; j < n; j++)
			cout << matrix[i * n + j] << "\t";

	int row_sum = first_row_sum(matrix, n);
	int col_sum = first_col_sum(matrix, n);
	cout << "\nThe sum of the elements of the first row: " << row_sum << endl;
	cout << "The sum of the elements of the first column: " << col_sum << endl;
	if (row_sum != col_sum)
	{
		cout << "The sums of the elements of the first row and the first column of the matrix are NOT the same!" << endl;
		return 0;
	}
	arr_change(matrix, n);
	cout << "The sums of the elements of the first row and the first column of the matrix are the same!" << endl;
	//matrix output 
	cout << "\nOutput matrix:" << endl;
	for (int i = 0; i < n; cout << endl, i++)
		for (int j = 0; j < n; j++)
			cout << matrix[i * n + j] << "\t";

	//memory release
	delete[]matrix;
	return 0;
}