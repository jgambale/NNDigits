# NNDigits
Midterm Digits project.

So far it has done what I need it to do.

test.m is the actual file of performing the digit rotation, then classifying.

genrotnet.m generates a separate net that "guesses" the angle by which to rotate the digit.

RotationLayer.m is a custom 2-input layer (of image/angle) that performs the rotation.


# Comments by the Reviewer

* processImagesMNIST is not a MATLAB built-in function. You must provide it for the code to run.
  See: [this link](https://www.mathworks.com/matlabcentral/answers/514716-i-cannot-find-the-helper-functions-processimagesmnist-and-processlabelsmnist)
* 
