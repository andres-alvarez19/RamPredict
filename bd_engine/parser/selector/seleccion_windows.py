# seleccion_windows.py
import os
import keyboard
from rich.console import Console
from rich.table import Table

console = Console()

def get_csv_files(directory):
    """Obtiene una lista de archivos .csv en un directorio dado."""
    return [f for f in os.listdir(directory) if f.endswith('.csv') and os.path.isfile(os.path.join(directory, f))]

def clear_screen():
    """Limpia la terminal."""
    os.system('cls' if os.name == 'nt' else 'clear')

def select_file_windows():
    """Función para seleccionar archivos en Windows usando rich y teclado."""
    directory = "../csv/"
    files = get_csv_files(directory)
    if not files:
        console.print("No hay archivos .csv en el directorio.")
        return None

    current_selection = 0

    while True:
        clear_screen()
        table = Table(title="Seleccionar archivo .csv")
        table.add_column("Archivo", justify="left")

        # Mostrar la lista de archivos .csv con la selección actual
        for index, filename in enumerate(files):
            if index == current_selection:
                table.add_row(f"> {filename}", style="bold reverse")
            else:
                table.add_row(f"  {filename}")

        console.print(table)

        # Esperar a que el usuario presione una tecla
        event = keyboard.read_event()
        
        if event.event_type == keyboard.KEY_DOWN and event.name == "up":
            current_selection = (current_selection - 1) % len(files)
        elif event.event_type == keyboard.KEY_DOWN and event.name == "down":
            current_selection = (current_selection + 1) % len(files)
        elif event.event_type == keyboard.KEY_DOWN and event.name == "enter":
            return directory + files[current_selection]

if __name__ == "__main__":
    selected_file = select_file_windows()
    if selected_file:
        print(f"Ruta archivo seleccionado: {selected_file}")
