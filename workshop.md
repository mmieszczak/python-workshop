# LTS programming workshop

---

## Agenda

- Understanding Python
- Zen of Python
- Static code analysis in Python
- Setuptools vs Poetry
- Code complexity
- Testability

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
b = a
# a and b reference the same object
print(a, id(a))  # output: 10 140641598177808
print(b, id(b))  # output: 10 140641598177808

a = 11
# Now a references a new object, while b remains unchanged
print(a, id(a))  # output: 11 140641598177840
print(b, id(b))  # output: 10 140641598177808
```

```c
// Equivalent code in C
void main() {
  int *a = &((int){10});
  int *b = a;
  printf("%d %p\n", *a, a); // output: 10 0x7ffd0782988c
  printf("%d %p\n", *b, b); // output: 10 0x7ffd0782988c

  a = &((int){11});
  printf("%d %p\n", *a, a); // output: 11 0x7ffd07829888
  printf("%d %p\n", *b, b); // output: 10 0x7ffd0782988c
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
- mccabe (code complexity)
- flake8 (pycodestyle + pyflakes)
- PyLama (pycodestyle + pyflakes and more)
- pylint (opionated code analyser)
- bandit (security checks)

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
Traceback (most recent call last):
  File "/home/user/repos/python-workshop/script.py", line 4, in <module>
    foo("some_string")
  File "/home/user/repos/python-workshop/script.py", line 2, in foo
    return some_int / 5
TypeError: unsupported operand type(s) for /: 'str' and 'int'
```

---

#### Type analysis tools

##### pyright/pylance

LSP, default in VSCode, created by Microsoft

```text
$ mypy script.py
script.py:4: error: Argument 1 to "foo" has incompatible type "str"; expected "int"
Found 1 error in 1 file (checked 1 source file)
```

##### mypy

Official CLI tool

```text
$ pyright script.py
/home/user/repos/python-workshop/script.py
  /home/user/repos/python-workshop/script.py:4:5 - error: Argument of type "Literal['some_string']" cannot be assigned to parameter "some_int" of type "int" in function "foo"
    "Literal['some_string']" is incompatible with "int" (reportGeneralTypeIssues)
```

---

## Packaging and dependency management

---

### Understanding PIP

---

### Setup a project

---

#### Bad workflow

No steup.py, no freezing

---

#### Better workflow

setup.py, freezing to requirements.txt

---

#### Poetry - the best workflor

---

## Code complexity

---

### Nesting

---

### Refactoring - extraction

---

### Refactoring - inversion

---

## Testability

---

### Dependency inversion

---

### Pure functions

---

### Side effects

---
