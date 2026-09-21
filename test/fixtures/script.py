import os


def f(x):
    return os.path.join(x, "y")


class Point:
    """Un point."""

    def norme(self):
        return (self.x ** 2 + self.y ** 2) ** 0.5
