# seleccion.py
import platform
import sys

def main():
    system = platform.system()

    if system == "Windows":
        from .seleccion_windows import select_file_windows
        selected_file = select_file_windows()
        if selected_file:
            return selected_file
    elif system == "Linux":
        import curses
        from .seleccion_linux import select_file_linux
        selected_file = curses.wrapper(select_file_linux)
        if selected_file:
            return selected_file

    else:
        print("Sistema operativo no soportado.")
        sys.exit(1)

if __name__ == "__main__":
    main()
