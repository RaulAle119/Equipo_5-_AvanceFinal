import platform

def analyze_system():
    system = platform.system()

    if system == "Windows":
        print("Estas en Windows")
    elif system == "Linux":
        print("Estas en Linux")
    else:
        print(f"El sistema operativo es: {system}")

if __name__ == "__main__":
    analyze_system()
