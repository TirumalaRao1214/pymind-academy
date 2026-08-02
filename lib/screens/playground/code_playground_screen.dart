import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../screens/lessons/widgets/code_block_widget.dart';

class CodePlaygroundScreen extends StatefulWidget {
  const CodePlaygroundScreen({super.key});

  @override
  State<CodePlaygroundScreen> createState() => _CodePlaygroundScreenState();
}

class _CodePlaygroundScreenState extends State<CodePlaygroundScreen> {
  int _selectedExample = 0;

  static const List<_PlaygroundExample> _examples = [
    _PlaygroundExample(
      title: 'Hello World',
      description: 'The classic first Python program',
      code: '''# Hello World in Python
print("Hello, World!")
print("Welcome to PyMind Academy!")

# You can print variables too
name = "Python Learner"
print(f"Hello, {name}!")''',
      output: '''Hello, World!
Welcome to PyMind Academy!
Hello, Python Learner!''',
    ),
    _PlaygroundExample(
      title: 'Variables & Types',
      description: 'Python variable assignment and types',
      code: '''# Variables in Python
name = "Alice"           # str
age = 25                 # int
score = 98.5             # float
is_active = True         # bool

print(type(name))        # <class 'str'>
print(type(age))         # <class 'int'>
print(f"{name} is {age} years old")''',
      output: '''<class 'str'>
<class 'int'>
Alice is 25 years old''',
    ),
    _PlaygroundExample(
      title: 'List Comprehension',
      description: 'Pythonic way to create lists',
      code: '''# List comprehension
squares = [x**2 for x in range(1, 6)]
print(squares)           # [1, 4, 9, 16, 25]

# With condition
evens = [x for x in range(10) if x % 2 == 0]
print(evens)             # [0, 2, 4, 6, 8]

# Nested
matrix = [[i*j for j in range(1,4)] for i in range(1,4)]
for row in matrix:
    print(row)''',
      output: '''[1, 4, 9, 16, 25]
[0, 2, 4, 6, 8]
[1, 2, 3]
[2, 4, 6]
[3, 6, 9]''',
    ),
    _PlaygroundExample(
      title: 'Functions & Lambda',
      description: 'Defining and using functions',
      code: '''# Regular function
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

print(greet("Alice"))
print(greet("Bob", "Hi"))

# Lambda function
square = lambda x: x ** 2
print(square(5))         # 25

# Higher-order functions
numbers = [1, 2, 3, 4, 5]
doubled = list(map(lambda x: x * 2, numbers))
print(doubled)           # [2, 4, 6, 8, 10]''',
      output: '''Hello, Alice!
Hi, Bob!
25
[2, 4, 6, 8, 10]''',
    ),
    _PlaygroundExample(
      title: 'Classes & OOP',
      description: 'Object-oriented programming in Python',
      code: '''# Python class
class Animal:
    def __init__(self, name, species):
        self.name = name
        self.species = species

    def speak(self):
        return f"{self.name} makes a sound"

    def __repr__(self):
        return f"Animal({self.name}, {self.species})"

class Dog(Animal):
    def speak(self):
        return f"{self.name} says: Woof!"

dog = Dog("Rex", "Canis lupus familiaris")
print(dog.speak())
print(repr(dog))
print(isinstance(dog, Animal))''',
      output: '''Rex says: Woof!
Animal(Rex, Canis lupus familiaris)
True''',
    ),
    _PlaygroundExample(
      title: 'Decorators',
      description: 'Python decorator pattern',
      code: '''import time

def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f}s")
        return result
    return wrapper

@timer
def slow_sum(n):
    return sum(range(n))

result = slow_sum(1_000_000)
print(f"Sum: {result}")''',
      output: '''slow_sum took 0.0412s
Sum: 499999500000''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final example = _examples[_selectedExample];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Playground'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share code',
            onPressed: () => Share.share(example.code,
                subject: example.title),
          ),
        ],
      ),
      body: Column(
        children: [
          // Example selector
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              itemCount: _examples.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == _selectedExample;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedExample = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primary
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? cs.primary
                            : cs.outline,
                      ),
                    ),
                    child: Text(
                      _examples[i].title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : cs.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(example.title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(example.description,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 14),

                  // Code block
                  CodeBlockWidget(code: example.code),
                  const SizedBox(height: 16),

                  // Output
                  Text('Output',
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E14),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFF3FB950).withOpacity(0.4)),
                    ),
                    child: SelectableText(
                      example.output,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 13,
                        height: 1.6,
                        color: Color(0xFF3FB950),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaygroundExample {
  final String title;
  final String description;
  final String code;
  final String output;

  const _PlaygroundExample({
    required this.title,
    required this.description,
    required this.code,
    required this.output,
  });
}
