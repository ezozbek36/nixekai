/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20260408 (64-bit version)
 * Copyright (c) 2000 - 2026 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of hosts/ayato/acpi-rp08-fix.aml
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000A8 (168)
 *     Revision         0x02
 *     Checksum         0xE4
 *     OEM ID           "CUSTOM"
 *     OEM Table ID     "RP08FIX"
 *     OEM Revision     0x00000001 (1)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20260408 (539362312)
 */
DefinitionBlock ("", "SSDT", 2, "CUSTOM", "RP08FIX", 0x00000001)
{
    External (_SB_.PC00.RP08, DeviceObj)
    External (_SB_.PC00.RP08.PXSX, DeviceObj)
    External (_SB_.PC00.PEG1.CMDR, FieldUnitObj)
    External (_SB_.PC00.PEG1.LREN, FieldUnitObj)
    External (_SB_.PC00.PEG1.D0ST, FieldUnitObj)
    External (_SB_.PC00.PEG1.CEDR, FieldUnitObj)
    External (_SB_.PC00.PEG1.PEGP.SSSV, FieldUnitObj)
    External (_SB_.PC00.PEG1.PEGP.HDAE, FieldUnitObj)
    External (_SB_.PC00.PEG1.PEGP.LTRE, IntObj)

    Scope (\_SB.PC00.RP08)
    {
        Alias (\_SB.PC00.PEG1.CMDR, CMDR)
        Alias (\_SB.PC00.PEG1.LREN, LREN)
        Alias (\_SB.PC00.PEG1.D0ST, D0ST)
        Alias (\_SB.PC00.PEG1.CEDR, CEDR)
    }

    Scope (\_SB.PC00.RP08.PXSX)
    {
        Alias (\_SB.PC00.PEG1.PEGP.SSSV, SSSV)
        Alias (\_SB.PC00.PEG1.PEGP.HDAE, HDAE)
        Alias (\_SB.PC00.PEG1.PEGP.LTRE, LTRE)
    }
}
