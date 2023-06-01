#include <iostream>
#include <string>
#include <vector>

extern "C" {
    void lr8(const char* sentence, int sentenceLength, char** result);
}

std::vector<std::string> findArithmeticProgression(const std::string& sentence) {
    std::vector<std::string> words;

    char** result = nullptr;
    lr8(sentence.c_str(), sentence.length(), result);

    if (result != nullptr) {
        for (int i = 0; result[i] != nullptr; ++i) {
            words.push_back(result[i]);
        }
    }

    return words;
}

int main() {
    std::cout << "Enter a sentence: ";
    std::string sentence;
    std::getline(std::cin, sentence);

    std::vector<std::string> sequence = findArithmeticProgression(sentence);

    if (!sequence.empty()) {
        std::cout << "Sequence found:" << std::endl;
        for (const auto& word : sequence) {
            std::cout << word << " (" << word.length() << " characters)" << std::endl;
        }
    }
    else {
        std::cout << "No sequence found." << std::endl;
    }

    return 0;
}
