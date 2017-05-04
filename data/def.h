#ifndef DEF_H
#define DEF_H

typedef int BOOL;

#define TRUE	1
#define FALSE	0

// CONFIGURE FILE FORMAT
#define CSV_COL_SEG					','
#define CSV_ROW_SEG					'\n'

// DATA FILE FORMAT REQUIREMENT
#define COLUMN_MAX_WIDTH            64
#define VARIABLE_NAME_LENGTH        64
#define VARIABLE_VALUE_LENGTH       64
#define MAX_CATEGORY_NUM 			128
#define DELTA_FACTOR				8 // min = 3

// NORMALIZATION METHODS
#define NORM_MIN_MAX				0

typedef int VALUE_TYPE;

#define VALUE_TYPE_NUMBER           0
#define VALUE_TYPE_STRING           1

typedef int VARIABLE_TYPE;

#define VARIABLE_TYPE_FLAG          0
#define VARIABLE_TYPE_CATEGORIAL    1
#define VARIABLE_TYPE_CONTINUOUS    2
#define VARIABLE_TYPE_NONE          3

typedef int VARIABLE_ROLE;
#define VARIABLE_ROLE_INPUT         0
#define VARIABLE_ROLE_NONE          1
#define VARIABLE_ROLE_TARGET        2

#define FILE_READ_BUFF_SIZE			256
#define FILE_WRITE_BUFF_SIZE		256




#define NUM_THREADS 1024
#define TARGET_ACCURACY 0.999
#define BATCH_SIZE 10240
#define BATCH_TOTAL 1024
#define ERROR_LAST_ITERATION 1
#define LEARNING_RATE 0.01
#define TRAIN_SAMPLE_NUM_RATIO 0.8


#define BLOCKSIZE 32


// MACRO & FUNCTIONS
#define F_SIGMOID( x ) ( 1.0 / ( 1.0 + expf( -x ) ) )

#define CUDA_CALL(func)\
  {\
    cudaError_t e = (func);\
    if(e != cudaSuccess)\
	cout << "LINE#"<<__LINE__<<": " << cudaGetErrorString(e) << endl;\
  }




typedef struct T_BPMODEL {
	int Train_cout;
	int batch_size;
	int In_nodes;
	int Hiden_nodes;
	int Out_nodes;
	float Alpha;
	float learn_r;
	float *W1;
	float *W2;
	float *B1;
	float *B2;
} BPModel;



// data structure of orginal data
typedef struct T_ORIGINAL_DATA {
	int col_num;
	int row_num;

	VARIABLE_TYPE * var_types;

    char ** variables;
	char *** values;
} table;

typedef table odata;

typedef struct T_NODE {
	void * data;
	struct T_NODE * prev;
	struct T_NODE * next;
} node;

typedef struct T_MATRIX {
	node * names;
	int * col_ids;
    int col_num;
    int row_num;
    float * data;
} matrix;

typedef matrix mdata;

typedef struct T_SPARSE_MATRIX {
    int col_num;
    int row_num;
    int total_nonzero;
    int * col_ids;
    int * row_ids;
    float * data;
} sparse_matrix;


typedef struct T_PARAM {
    /*** read data ***/
	int norm_method; // normalization method type
	float pearson_thread; // pearson threshold
    int batch_size; // batch size for one iteration
    int iter_num; // total number of iteration
    /*** logistic regression ****/

    /*** bp network ****/
	BPModel *bp_model;

} param;


#define _ASSERT(x) {\
    if ( !(x) ) {\
        fprintf( stdout, "ASSERT ERROR: %d@%s\n", __LINE__, __FILE__ );\
        exit(1);\
    }\
}


#endif // DEF_H
