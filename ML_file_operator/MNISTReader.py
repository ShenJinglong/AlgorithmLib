# -*- coding: utf-8 -*-

import numpy as np
import imageio

class MNISTImageReader():
    """
    brief: read image data from .idx3-ubyte file as numpy array
    use cases:
        # case 1
        with MNISTImageReader('t10k-images.idx3-ubyte') as reader:
            # the reader was designed as a iterable object.
            for index, image in reader:
                ...
        
        # case 2
        reader = MNISTImageReader('t10k-images.idx3-ubyte')
        reader.open()
        # read 10 images from source file. 
        # the result is returned as dictionary with index as key and image as value
        images = reader.read(10) 
        reader.close()

        # case 3
        with MNISTImageReader('t10k-images.idx3-ubyte') as reader:
            images = reader.read(10) # Of course, you can access images using read() within 'with' context.
    """
    _expected_magic = 2051
    _current_index = 0

    def __init__(self, path):
        if not path.endswith('.idx3-ubyte'):
            raise NameError("File must be a '.idx3-ubyte' extension")
        self.__path = path
        self.__file_object = None

    def __enter__(self):
        self.__file_object = open(self.__path, 'rb')

        magic_number = int.from_bytes(self.__file_object.read(4), byteorder='big')
        if magic_number != self._expected_magic:
            raise TypeError("The File is not a properly formatted .idx3-ubyte file!")
        
        self.__num_of_images = int.from_bytes(self.__file_object.read(4), byteorder='big')
        print(f'Total {self.__num_of_images} images ...')
        self.__num_of_rows = int.from_bytes(self.__file_object.read(4), byteorder='big')
        self.__num_of_cols = int.from_bytes(self.__file_object.read(4), byteorder='big')
        return self
    
    def __exit__(self, type, val, tb):
        self.__file_object.close()

    def __iter__(self):
        return self

    def __next__(self):
        raw_image_data = self.__file_object.read(self.__num_of_rows * self.__num_of_cols)
        if self.__file_object is None or raw_image_data == b'':
            raise StopIteration
        else:
            self._current_index += 1
            return self._current_index, np.frombuffer(raw_image_data, dtype=np.uint8).reshape((self.__num_of_rows, self.__num_of_cols))

    def read(self, num):
        result = dict()
        for i in range(num):
            raw_image_data = self.__file_object.read(self.__num_of_rows * self.__num_of_cols)
            if self.__file_object is None or raw_image_data == b'':
                break
            else:
                self._current_index += 1
                result[f'{self._current_index}'] = np.frombuffer(raw_image_data, dtype=np.uint8).reshape((self.__num_of_rows, self.__num_of_cols))
        return result

    def open(self):
        self.__file_object = open(self.__path, 'rb')

        magic_number = int.from_bytes(self.__file_object.read(4), byteorder='big')
        if magic_number != self._expected_magic:
            raise TypeError("The File is not a properly formatted .idx3-ubyte file!")
        
        self.__num_of_images = int.from_bytes(self.__file_object.read(4), byteorder='big')
        print(f'Total {self.__num_of_images} images ...')
        self.__num_of_rows = int.from_bytes(self.__file_object.read(4), byteorder='big')
        self.__num_of_cols = int.from_bytes(self.__file_object.read(4), byteorder='big')

    def close(self):
        self.__file_object.close()




class MNISTLabelReader():
    """
    brief: read label data from .idx1-ubyte file as integer (0, 1, ..., 9)
    use cases:
        # case 1
        with MNISTLabelReader('t10k-labels.idx1-ubyte') as reader:
            # the reader was designed as a iterable object.
            for index, label in reader:
                ...
        
        # case 2
        reader = MNISTLabelReader('t10k-labels.idx1-ubyte')
        reader.open()
        # read 10 labels from source file. 
        # the result is returned as dictionary with index as key and label as value
        images = reader.read(10) 
        reader.close()

        # case 3
        with MNISTImageReader('t10k-images.idx3-ubyte') as reader:
            images = reader.read(10) # Of course, you can access labels using read() within 'with' context.
    """
    _expected_magic = 2049
    _current_index = 0

    def __init__(self, path):
        if not path.endswith('.idx1-ubyte'):
            raise NameError("File must be a '.idx1-ubyte' extension")
        self.__file_path = path
        self.__file_object = None

    def __enter__(self):
        self.__file_object = open(self.__file_path, 'rb')

        magic_number = int.from_bytes(self.__file_object.read(4), byteorder='big')
        if magic_number != self._expected_magic:
            raise TypeError("The File is not a properly formatted .idx1-ubyte file!")
        self.__num_of_labels = int.from_bytes(self.__file_object.read(4), byteorder='big')
        print(f'Total {self.__num_of_labels} labels ...')

        return self

    def __exit__(self, *args, **kwargs):
        self.__file_object.close()

    def __iter__(self):
        return self

    def __next__(self):
        raw_label = self.__file_object.read(1)
        if self.__file_object is None or raw_label == b'':
            raise StopIteration
        else:
            self._current_index += 1
            return self._current_index, int.from_bytes(raw_label, byteorder='big')

    def read(self, num):
        result = dict()
        for i in range(num):
            raw_label = self.__file_object.read(1)
            if self.__file_object is None or raw_label == b'':
                break
            else:
                self._current_index += 1
                result[f'{self._current_index}'] = int.from_bytes(raw_label, byteorder='big')
        return result

    def open(self):
        self.__file_object = open(self.__file_path, 'rb')

        magic_number = int.from_bytes(self.__file_object.read(4), byteorder='big')
        if magic_number != self._expected_magic:
            raise TypeError("The File is not a properly formatted .idx1-ubyte file!")
        self.__num_of_labels = int.from_bytes(self.__file_object.read(4), byteorder='big')
        print(f'Total {self.__num_of_labels} labels ...')

    def close(self):
        self.__file_object.close()
