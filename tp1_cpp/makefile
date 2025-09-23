# Compilador e flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17

# Diretórios
SRC_DIR = .
BUILD_DIR = build

# Fontes
SRCS = prob1.cpp prob2.cpp

# Executáveis
EXES = $(SRCS:%.cpp=$(BUILD_DIR)/%)

# Regra padrão: compilar tudo
all: $(EXES)

# Como compilar cada .cpp em executável
$(BUILD_DIR)/%: %.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $< -o $@

# Criar diretório build se não existir
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Rodar prob1
run_p1: $(BUILD_DIR)/prob1
	cls
	./$(BUILD_DIR)/prob1

# Rodar prob2
run_p2: $(BUILD_DIR)/prob2
	./$(BUILD_DIR)/prob2

# Limpar arquivos gerados
clean:
	rm -rf $(BUILD_DIR)/*
