import typer

# Create the Typer app
app = typer.Typer(help="A sample CLI application built with Typer.")

# Main command
def main(name: str, age: int = typer.Option(..., help="Your age")):
    """Greet the user with their name and age."""
    typer.echo(f"Hello, {name}! You are {age} years old.")

app.command()(main)

# Subcommand: Add numbers
@app.command()
def add(a: int, b: int):
    """Add two numbers."""
    result = a + b
    typer.echo(f"The result of adding {a} and {b} is {result}.")

# Subcommand: Subtract numbers
@app.command()
def subtract(a: int, b: int):
    """Subtract two numbers."""
    result = a - b
    typer.echo(f"The result of subtracting {b} from {a} is {result}.")

# Subcommand: Async example
@app.command()
async def async_example():
    """Demonstrate an async subcommand."""
    typer.echo("This is an async command!")

# Subcommand: Custom greeting
@app.command()
def custom_greeting(
    name: str = typer.Argument(..., help="Your name"),
    uppercase: bool = typer.Option(False, help="Convert greeting to uppercase")
):
    """Provide a custom greeting."""
    greeting = f"Hello, {name}!"
    if uppercase:
        greeting = greeting.upper()
    typer.echo(greeting)

if __name__ == "__main__":
    app()
