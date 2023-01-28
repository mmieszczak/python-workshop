# LTS programming workshop

---

## Agenda

- Understanding Python
- Zen of Python
- Static code analysis in Python
- Packaging and dependency management

---

## Understanding Python

---

### Interpreter

Interpreter (also called virtual machine) is a program that executes a Python script.
Before execution, Python source code is compiled into bytecode,
which can be understood by the interpreter.

---

#### Interpreter implementations

- CPython (official implementation)
- PyPy (fast alternative implementation, faeturing JIT)
- Jython (runs on JVM)
- Iron Python (integrated with .NET)
- MicroPython (designed to run on microcontrollers)

---

### There is a module for everything

- Data science (NumPy, pandas, matplotlib, SciPy)
- Machine learning (PyTorch, Tensorflow)
- Web development (Django, Flask, FastAPI)
- Web scraping (BeautifulSoup, Selenium)
- GUI applications (PyQT, PySide, Kivy, Tkinter)
- Image manipulation (Pillow)
- Game development (Pygame, Pyglet)
- API client libraries for many services

---

### Dynamic typing

Dynamic typing means, that types are checked during program runtime,
in contrast to staticaly typed languages, which perform this check during compilation.

---

### EVERYTHING is an object

Everything including integers, strings, lists is an object.
Event functions, classes (as in class definitions) and modules are objects.
This means, that everything has an `id`, can be assigned to a name,
passed as an argument or even dynamically created at runtime.

---

### References

All assignments in Python are done by reference.
This means, that objects are not copied during assignment.
It is also true when you pass arguments to functions.

You can think of an object id as a memory address

---

#### Assignment example

```python
a = 10
b = a  # a and b reference the same object
print(a, id(a))  # output: 10 140641598177808
print(b, id(b))  # output: 10 140641598177808
a = 11  # Now a references a new object, while b remains unchanged
print(a, id(a))  # output: 11 140641598177840
print(b, id(b))  # output: 10 140641598177808
```

```c
// Similar code in C
void main() {
  int a = 10;
  int b = a; // Value of a is copied to variable b
  printf("%d %p\n", a, &a); // output: 10 0x7ffd07829888
  printf("%d %p\n", b, &b); // output: 10 0x7ffd0782988c
  a = 11;
  printf("%d %p\n", a, &a); // output: 11 0x7ffd07829888
  printf("%d %p\n", b, &b); // output: 10 0x7ffd0782988c
}
```

---

#### Function example

```python
# Python passes arguments by reference, ids are the same
def foo(a):
    print(a, id(a))  # output: 10 140519034323472

a = 10
print(a, id(a))  # output: 10 140519034323472

foo(a)
```

```c
// C passes arguments by value, addresses are different
void foo(int a) {
  printf("%d %p\n", a, &a); // output: 10 0x7ffd5699f84c
}

void main() {
  int a = 10;
  printf("%d %p\n", a, &a); // output: 10 0x7ffd5699f87c
  foo(a);
}
```

---

### Immutable vs mutable types

---

#### Immutable builtin types

- number (int, float, complex)
- str
- tuple
- frozenset
- bytes

---

#### Immutable example (int)

We can increment an integer, but the original object remains untouched.
Instead Python creates a new integer object with value increased by one
and assigns it to the original name.

```python
a = 10
print(a, id(a))  # output: 10 140568096735760
a += 1
print(a, id(a))  # output: 11 140568096735792
```

```c
// C increments value in place, so the address does not change
void main() {
  int a = 10;
  printf("%d %p\n", a, &a); // output 10 0x7fff6401d9fc
  a += 1;
  printf("%d %p\n", a, &a); // output 11 0x7fff6401d9fc
}
```

---

#### Immutable example (tuple)

```python
t = (0, 1, 2)
t[0] = 3  # TypeError: 'tuple' object does not support item assignment
```

---

#### Mutable builtin types

- list
- dict
- set
- bytearray

---

#### Mutable example

```python
a = [2, 1, 3, 7]
b = a
c = a.copy()
a.append(5)
print(a, id(a))  # output: [2, 1, 3, 7, 5] 140568094536832
print(b, id(b))  # output: [2, 1, 3, 7, 5] 140568094536832
print(c, id(c))  # output: [2, 1, 3, 7] 140568094535488
```

---

## Zen of Python

```python
>>> import this
```

---

- Beautiful is better than ugly.
- Explicit is better than implicit.
- Simple is better than complex.
- Complex is better than complicated.
- Flat is better than nested.
- Sparse is better than dense.
- Readability counts.
- Special cases aren't special enough to break the rules.
- Although practicality beats purity.

---

- Errors should never pass silently.
- Unless explicitly silenced.
- In the face of ambiguity, refuse the temptation to guess.
- There should be one-- and preferably only one --obvious way to do it.
- Although that way may not be obvious at first unless you're Dutch.

---

- Now is better than never.
- Although never is often better than _right_ now.
- If the implementation is hard to explain, it's a bad idea.
- If the implementation is easy to explain, it may be a good idea.
- Namespaces are one honking great idea -- let's do more of those!

---

## Static code analysis in Python

---

### Linting

Linting helps you find errors before you ever run the code.
You can enable linters in your code editor,
so they are run automatically.

---

#### Linting tools

- pyflakes (syntax checks)
- pycodestyle (PEP8 style checks)
- flake8 (pycodestyle + pyflakes)
- PyLama (pycodestyle + pyflakes and more)
- pylint (opionated code analyser)
- bandit (security checks)
- mccabe (Cyclomatic Complexity)
- radon (code metrics)

---

### Formatting

Autoformatters let you maintain consistent codestyle across projects.

---

#### Autoformatting tools

- autopep8 (basic autoformatting, only fixes PEP8 violations)
- black (formats entire file, even if there are no PEP8 violations)
- yapf (reformats entire code to the "best" formatting
  that conforms to style guide)
- isort (sort imports)

---

### Static type analysis

Lets you catch TypeError bugs without ever running the code.

---

#### Example code with a type error

```python
# script.py
def foo(some_int: int) -> float:
    return some_int / 2

foo("some_string")
```

```text
$ python script.py
Traceback (most recent call last):
  File "/home/user/repos/python-workshop/script.py", line 4, in <module>
    foo("some_string")
  File "/home/user/repos/python-workshop/script.py", line 2, in foo
    return some_int / 5
           ~~~~~~~~~^~~
TypeError: unsupported operand type(s) for /: 'str' and 'int'
```

---

#### Type analysis tools

##### pyright/pylance

LSP, default in VSCode, created by Microsoft

```text
$ pyright script.py
/home/user/repos/python-workshop/script.py
  /home/user/repos/python-workshop/script.py:4:5 - error: Argument of type "Literal['some_string']" cannot be assigned to parameter "some_int" of type "int" in function "foo"
    "Literal['some_string']" is incompatible with "int" (reportGeneralTypeIssues)
```

##### mypy

Official CLI tool

```text
$ mypy script.py
script.py:4: error: Argument 1 to "foo" has incompatible type "str"; expected "int"
Found 1 error in 1 file (checked 1 source file)
```

---

## Packaging and dependency management

---

### Understanding PIP

---

#### PyPI

PyPI (Python Package Index) - central package repository.

---

#### Installing packages

##### Global as root (don't do that)

```bash
sudo pip install <package-name>
# Installs to /usr/local
```

##### Global per-user

```bash
pip install --user <package-name>
# Installs to ~/.local
```

##### In venv

```bash
python -m venv .venv
. .venv/bin/activate
pip install <package-name>
# Installs to .venv
```

---

### Setup a project

```bash
mkdir -p my_test_package
touch my_test_package/{__init__.py,main.py} README.md
```

```python
# main.py
def main():
    print("Hello world!")


if __name__ == "__main__":
    main()
```

---

#### Typical workflow

```bash
# Define dependencies
echo requests >> requirements.txt
echo beautifulsoup4 >> requirements.txt

# Create venv
python -m venv .venv
. .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run script
python my_test_package/main.py
```

---

#### Workflow using setuptools

setup.py

```python
import setuptools
setuptools.setup()
```

setup.cfg

```cfg
[options]
packages = find:
install_requires =
  requests ~= 2.28.2
  beautifulsoup4 ~= 4.11.1
  importlib-metadata; python_version>="3.10"

[options.entry_points]
console_scripts =
  my-test-exec = my_test_package.main:main
```

---

```bash
# Create and activate venv
python -m venv .venv
. .venv/bin/activate

# Optional: install dependencies from frozen requirements.txt
pip install -r requirements.txt

# Install package to venv
python setup.py develop
# or
pip install -e .

# Run script
my-test-exec
```

---

Freeze dependencies

```bash
pip freeze --exclude-editable > requirements.txt
```

requirements.txt

```text
beautifulsoup4==4.11.1
certifi==2022.12.7
charset-normalizer==3.0.1
idna==3.4
requests==2.28.2
soupsieve==2.3.2.post1
urllib3==1.26.14
```

---

#### Workflow using poetry

pyproject.toml

```toml
[tool.poetry]
name = "my_test_package"
version = "0.1.0"
description = "My test package"
authors = ["Michał Mieszczak <m.mieszczak@piwik.pro>"]
readme = "README.md"

[tool.poetry.scripts]
my-test-exec = 'my_test_package.main:main'

[tool.poetry.dependencies]
python = "^3.10"
requests = "^2.28.2"
beautifulsoup4 = "^4.11.1"

[tool.poetry.group.dev.dependencies]
black = "^22.12.0"
pylama = "^8.4.1"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

---

```bash
# Guided project initialization
poetry init

# Install package and dependencies to venv
poetry install

# Run script
poetry run my-test-exec
# Or run from sub-shell
poetry shell
my-test-exec
```

---

## Clean code

---

### Use meaningful names

Do not use comments to describe what a variable represents
ant what it is used for.
Use proper, descriptive name instead.

---

### Functions

Functions should be small and do one thing only.
Name of the function should clearly describe what it does.

---

### Don't repeat yourself

Whenever you do something many times in your code,
consider extracting this functionality into a separate,
reusable function/class/module.

---

### Nesting

Deeply nested `if` statements and loops,
make the code more difficult to follow.
You can use techniques such as _extraction_
and _inversion_ to make your code flatter
and easier to read.

---

#### Nesting example

```python
def sum_even_in_range(bottom: int, top: int):
    if top > bottom:
        sum_ = 0
        for number in range(bottom, top):
            if number % 2 == 0:
                sum_ += number
        return sum_
    else:
        return 0
```

---

#### Inversion

```python
def sum_even_in_range(bottom: int, top: int):
    if top <= bottom:
        return 0

    sum_ = 0
    for number in range(bottom, top):
        if number % 2 == 0:
            sum_ += number
    return sum_
```

---

#### Extraction

```python
def filter_even(number: int):
    if number % 2 == 0:
        return number
    return 0

def sum_even_in_range(bottom: int, top: int):
    if top <= bottom:
        return 0

    sum_ = 0
    for number in range(bottom, top):
        sum_ += filter_even(number)
    return sum_
```

---

#### Bonus functional solution

```python
def filter_even(number: int):
    if number % 2 == 0:
        return number
    return 0

def sum_even_in_range(bottom: int, top: int):
    if top <= bottom:
        return 0

    return sum(map(filter_even, range(bottom, top)))
```

---

### Dependency inversion

Functions and methods deep down inside the business logic
should not be responsible for creating and managing resources.
It is a good idea, to manage resources outside
and pass them as arguments.

---

LogWriter opens and closes the file.

```python
class LogWriter:
    def __init__(self, log_file_path: str):
        self.log_file = open(log_file_path, "a")

    def info(self, message: str):
        self.log_file.write(f"INFO: {message}\n")

    def close(self):
        self.log_file.close()

logger = LogWriter("test.log")
logger.info("some logging info")
logger.info("other message")
logger.close()
```

---

LogWriter uses file opened outside.
It can also work with any other text buffer.
This makes the class much more flexible and generic.

```python
import io

class LogWriter:
    def __init__(self, log_file: io.TextIOWrapper):
        self.log_file = log_file

    def info(self, message: str):
        self.log_file.write(f"INFO: {message}\n")

with open("test.log", "a") as file:
    logger = LogWriter(file)
    logger.info("some logging info")
    logger.info("other message")

string_log = io.StringIO()
logger = LogWriter(string_log)
logger.info("message logged to string buffer")
```

---
