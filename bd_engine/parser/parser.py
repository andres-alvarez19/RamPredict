import pandas as pd
import mysql.connector
from selector import seleccion
import db_config

# Obtén el archivo seleccionado con seleccion.py
ruta = seleccion.main()
print(f"Archivo seleccionado: {ruta}")

# Cargar el archivo CSV
data = pd.read_csv(ruta)

# Preparar los DataFrames para cada tabla
muestras_df = data[['Resultado', 'Concentracion_RAM', 'Tipo_Purin', 'Volumen_Muestra', 'pH_Muestra', 'Comentarios']].copy()
muestras_df.columns = ['resultado', 'concentracion_ram', 'tipo_purin', 'volumen_muestra', 'ph_muestra', 'comentarios']

condiciones_ambientales_df = data[['Temperatura_Muestra', 'Temperatura_Ambiental', 'Humedad_Relativa', 'Condiciones_Meteorologicas', 'Hora_Recoleccion']].copy()
condiciones_ambientales_df.columns = ['temperatura_muestra', 'temperatura_ambiental', 'humedad_relativa', 'condiciones_meteorologicas', 'hora_recoleccion']

tratamiento_muestra_df = data[['Tratamientos_Previos', 'Metodo_Conservacion', 'Tiempo_Almacenamiento', 'Condiciones_Transporte']].copy()
tratamiento_muestra_df.columns = ['tratamientos_previos', 'metodo_conservacion', 'tiempo_almacenamiento', 'condiciones_transporte']

caracteristicas_fundo_df = data[['Ubicacion_Geografica', 'Caracteristicas_Fundo']].copy()
caracteristicas_fundo_df.columns = ['ubicacion_geografica', 'caracteristicas_fundo']

animales_df = data[['Edad_Promedio', 'Estado_Salud', 'Cantidad_Animales', 'Dieta_Animales', 'Uso_Antibioticos']].copy()
animales_df.columns = ['edad_promedio', 'estado_salud', 'cantidad_animales', 'dieta_animales', 'uso_antibioticos']

analisis_df = data[['Fecha_Analisis', 'Metodo_Analisis', 'Parametros_Calidad', 'Cebadores_Sondas', 'Concentracion_Materia_Organica', 'Carga_Microbiana', 'Diversidad_Microbiana']].copy()
analisis_df.columns = ['fecha_analisis', 'metodo_analisis', 'parametros_calidad', 'cebadores_sondas', 'concentracion_materia_organica', 'carga_microbiana', 'diversidad_microbiana']

# Conexión a la base de datos MySQL con collation compatible
def connect_to_db():
    try :
        connection = mysql.connector.connect(
            host=db_config.DB_HOST,
            user=db_config.DB_USER,
            password=db_config.DB_PASSWORD,
            database=db_config.DB_NAME,
            port=db_config.DB_PORT,
            charset=db_config.DB_CHARSET,
            collation=db_config.DB_COLLATION
        )
        print("Conexión a la base de datos exitosa.")
    except Exception as e:
        print("Error al conectar a la base de datos:", e)
        print("Asegúrate de que el servidor MySQL esté en ejecución.")
        connection = None
    return connection

# Funciones de inserción para cada tabla
def insert_muestras(connection, muestras_df):
    cursor = connection.cursor()
    for _, row in muestras_df.iterrows():
        cursor.execute("""
            INSERT INTO Muestras (resultado, concentracion_ram, tipo_purin, volumen_muestra, ph_muestra, comentarios)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            row['resultado'],
            row['concentracion_ram'],
            row['tipo_purin'],
            row['volumen_muestra'],
            row['ph_muestra'],
            row['comentarios']
        ))
        connection.commit()
    cursor.close()

def insert_condiciones_ambientales(connection, condiciones_ambientales_df):
    cursor = connection.cursor()
    for idx, row in condiciones_ambientales_df.iterrows():
        cursor.execute("""
            INSERT INTO CondicionesAmbientales (muestra_id, temperatura_muestra, temperatura_ambiental, humedad_relativa, condiciones_meteorologicas, hora_recoleccion)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            idx + 1,
            row['temperatura_muestra'],
            row['temperatura_ambiental'],
            row['humedad_relativa'],
            row['condiciones_meteorologicas'],
            row['hora_recoleccion']
        ))
        connection.commit()
    cursor.close()

def insert_tratamiento_muestra(connection, tratamiento_muestra_df):
    cursor = connection.cursor()
    for idx, row in tratamiento_muestra_df.iterrows():
        cursor.execute("""
            INSERT INTO TratamientoMuestra (muestra_id, tratamientos_previos, metodo_conservacion, tiempo_almacenamiento, condiciones_transporte)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            idx + 1,
            row['tratamientos_previos'],
            row['metodo_conservacion'],
            row['tiempo_almacenamiento'],
            row['condiciones_transporte']
        ))
        connection.commit()
    cursor.close()

def insert_caracteristicas_fundo(connection, caracteristicas_fundo_df):
    cursor = connection.cursor()
    for idx, row in caracteristicas_fundo_df.iterrows():
        cursor.execute("""
            INSERT INTO CaracteristicasFundo (muestra_id, ubicacion_geografica, caracteristicas_fundo)
            VALUES (%s, %s, %s)
        """, (
            idx + 1,
            row['ubicacion_geografica'],
            row['caracteristicas_fundo']
        ))
        connection.commit()
    cursor.close()

def insert_animales(connection, animales_df):
    cursor = connection.cursor()
    for idx, row in animales_df.iterrows():
        cursor.execute("""
            INSERT INTO Animales (muestra_id, edad_promedio, estado_salud, cantidad_animales, dieta_animales, uso_antibioticos)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            idx + 1,
            row['edad_promedio'],
            row['estado_salud'],
            row['cantidad_animales'],
            row['dieta_animales'],
            row['uso_antibioticos']
        ))
        connection.commit()
    cursor.close()

def insert_analisis(connection, analisis_df):
    cursor = connection.cursor()
    for idx, row in analisis_df.iterrows():
        cursor.execute("""
            INSERT INTO Analisis (muestra_id, fecha_analisis, metodo_analisis, parametros_calidad, cebadores_sondas, concentracion_materia_organica, carga_microbiana, diversidad_microbiana)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            idx + 1,
            row['fecha_analisis'],
            row['metodo_analisis'],
            row['parametros_calidad'],
            row['cebadores_sondas'],
            row['concentracion_materia_organica'],
            row['carga_microbiana'],
            row['diversidad_microbiana']
        ))
        connection.commit()
    cursor.close()

# Ejecutar la inserción de datos en todas las tablas
def main():
    connection = connect_to_db()
    try:
        insert_muestras(connection, muestras_df)
        insert_condiciones_ambientales(connection, condiciones_ambientales_df)
        insert_tratamiento_muestra(connection, tratamiento_muestra_df)
        insert_caracteristicas_fundo(connection, caracteristicas_fundo_df)
        insert_animales(connection, animales_df)
        insert_analisis(connection, analisis_df)
        print("Datos insertados en todas las tablas exitosamente.")
    except Exception as e:
        print("Error al insertar datos:", e)
    finally:
        connection.close()

# Ejecutar el script
main()

