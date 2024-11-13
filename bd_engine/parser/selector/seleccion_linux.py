# seleccion_linux.py
import os
import curses

def get_csv_files(directory):
    """Obtiene una lista de archivos .csv en un directorio dado."""
    return [f for f in os.listdir(directory) if f.endswith('.csv') and os.path.isfile(os.path.join(directory, f))]

def clear_screen():
    """Limpia la terminal."""
    os.system('clear')

def select_file_linux(stdscr):
    """Función para seleccionar archivos en Linux usando curses."""
    directory = "../csv/"
    files = get_csv_files(directory)
    if not files:
        stdscr.addstr("No hay archivos .csv en el directorio.\n")
        stdscr.getch()
        return None

    curses.curs_set(0)
    current_selection = 0

    while True:
        clear_screen()
        stdscr.clear()
        stdscr.addstr("Seleccionar archivo .csv (use ↑/↓ para navegar, Enter para seleccionar):\n")

        for index, filename in enumerate(files):
            if index == current_selection:
                stdscr.addstr(f"> {filename}\n", curses.A_REVERSE)
            else:
                stdscr.addstr(f"  {filename}\n")

        key = stdscr.getch()

        # Navegación con flechas
        if key == curses.KEY_UP:
            current_selection = (current_selection - 1) % len(files)
        elif key == curses.KEY_DOWN:
            current_selection = (current_selection + 1) % len(files)
        elif key == ord('\n'):
            return directory + files[current_selection]

if __name__ == "__main__":
    curses.wrapper(select_file_linux)
