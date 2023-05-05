#include <iostream>
#include <intrin.h>

int main() {
    unsigned int stepping;
    bool rdmsr_supported, wrmsr_supported;
    unsigned int eax, ebx, ecx, edx;

    __asm {
        ; call CPUID with EAX = 1 to get stepping and MSR support information
        mov eax, 1
        cpuid
        mov stepping, eax
        mov eax, ecx
        and eax, 32; check bit 5 (CR4.MSR)
        setnz al
        mov rdmsr_supported, al
        mov wrmsr_supported, al

        ; read the value of MSR with index 0x1B
        cmp rdmsr_supported, 0
        jz wrmsr_check
        mov ecx, 0x1B
        rdmsr
        mov eax, edx
        mov ebx, ecx
        shr edx, 32
        shr ecx, 32
        mov ecx, eax
        mov eax, ebx
        jmp done

        wrmsr_check :
        ; write the value 0x12345678 to the MSR with index 0x1B
            cmp wrmsr_supported, 0
            jz done
            mov eax, 0x12345678
            mov edx, eax
            mov ecx, 0x1B
            wrmsr

            done :
    }

    std::cout << "Stepping: " << stepping << std::endl;
    std::cout << "RDMSR supported: " << (rdmsr_supported ? "Yes" : "No") << std::endl;
    std::cout << "WRMSR supported: " << (wrmsr_supported ? "Yes" : "No") << std::endl;

    return 0;
}


