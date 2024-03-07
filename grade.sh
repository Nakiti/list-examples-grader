CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f "student-submission/ListExamples.java" ]; then 
    echo "file found!"
else 
    echo "ListExamples.java not found!"
    exit 1
fi

#jar
cp -r lib grading-area

# ListExamples
cp student-submission/ListExamples.java grading-area/

#TestListExamples
cp TestListExamples.java grading-area/

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]; then
    echo "Complie error!"
else
    echo "Compiled successfully!"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -2)
ok=$(grep -o "OK" junit-output.txt)

if [[ "$ok" =~ "OK" ]]; then
    tests=$(echo $lastline | awk -F'[ (]' '{print $3}')
    echo "Your score is $tests / $tests "
else 
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes=$(( tests - failures ))
    echo "Your score is $successes / $tests"
fi

