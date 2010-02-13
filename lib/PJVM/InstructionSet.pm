package PJVM::InstructionSet;

use strict;
use warnings;

use constant {
    JVM_OP_aaload => 0x32,
    JVM_OP_aastore => 0x53,
    JVM_OP_aconst_null => 0x01,
    JVM_OP_aload => 0x19,
    JVM_OP_aload_0 => 0x2a,
    JVM_OP_aload_1 => 0x2b,
    JVM_OP_aload_2 => 0x2c,
    JVM_OP_aload_3 => 0x2d,
    JVM_OP_anewarray => 0xbd,
    JVM_OP_areturn => 0xb0,
    JVM_OP_arraylength => 0xbe,
    JVM_OP_astore => 0x3a,
    JVM_OP_astore_0 => 0x4b,
    JVM_OP_astore_1 => 0x4c,
    JVM_OP_astore_2 => 0x4d,
    JVM_OP_astore_3 => 0x4e,
    JVM_OP_athrow => 0xbf,
    JVM_OP_baload => 0x33,
    JVM_OP_bastore => 0x54,
    JVM_OP_bipush => 0x10,
    JVM_OP_caload => 0x34,
    JVM_OP_castore => 0x55,
    JVM_OP_checkcast => 0xc0,
    JVM_OP_d2f => 0x90,
    JVM_OP_d2i => 0x8e,
    JVM_OP_d2l => 0x8f,
    JVM_OP_dadd => 0x63,
    JVM_OP_daload => 0x31,
    JVM_OP_dastore => 0x52,
    JVM_OP_dcmpg => 0x98,
    JVM_OP_dcmpl => 0x97,
    JVM_OP_dconst_0 => 0x0e,
    JVM_OP_dconst_1 => 0x0f,
    JVM_OP_ddiv => 0x6f,
    JVM_OP_dload => 0x18,
    JVM_OP_dload_0 => 0x26,
    JVM_OP_dload_1 => 0x27,
    JVM_OP_dload_2 => 0x28,
    JVM_OP_dload_3 => 0x29,
    JVM_OP_dmul => 0x6b,
    JVM_OP_dneg => 0x77,
    JVM_OP_drem => 0x73,
    JVM_OP_dreturn => 0xaf,
    JVM_OP_dstore => 0x39,
    JVM_OP_dstore_0 => 0x47,
    JVM_OP_dstore_1 => 0x48,
    JVM_OP_dstore_2 => 0x49,
    JVM_OP_dstore_3 => 0x4a,
    JVM_OP_dsub => 0x67,
    JVM_OP_dup => 0x59,
    JVM_OP_dup2 => 0x5c,
    JVM_OP_dup2_x1 => 0x5d,
    JVM_OP_dup2_x2 => 0x5e,
    JVM_OP_dup_x1 => 0x5a,
    JVM_OP_dup_x2 => 0x5b,
    JVM_OP_f2d => 0x8d,
    JVM_OP_f2i => 0x8b,
    JVM_OP_f2l => 0x8c,
    JVM_OP_fadd => 0x62,
    JVM_OP_faload => 0x30,
    JVM_OP_fastore => 0x51,
    JVM_OP_fcmpg => 0x96,
    JVM_OP_fcmpl => 0x95,
    JVM_OP_fconst_0 => 0x0b,
    JVM_OP_fconst_1 => 0x0c,
    JVM_OP_fconst_2 => 0x0d,
    JVM_OP_fdiv => 0x6e,
    JVM_OP_fload => 0x17,
    JVM_OP_fload_0 => 0x22,
    JVM_OP_fload_1 => 0x23,
    JVM_OP_fload_2 => 0x24,
    JVM_OP_fload_3 => 0x25,
    JVM_OP_fmul => 0x6a,
    JVM_OP_fneg => 0x76,
    JVM_OP_frem => 0x72,
    JVM_OP_freturn => 0xae,
    JVM_OP_fstore => 0x38,
    JVM_OP_fstore_0 => 0x43,
    JVM_OP_fstore_1 => 0x44,
    JVM_OP_fstore_2 => 0x45,
    JVM_OP_fstore_3 => 0x46,
    JVM_OP_fsub => 0x66,
    JVM_OP_getfield => 0xb4,
    JVM_OP_getstatic => 0xb2,
    JVM_OP_goto => 0xa7,
    JVM_OP_goto_w => 0xc8,
    JVM_OP_i2b => 0x91,
    JVM_OP_i2c => 0x92,
    JVM_OP_i2d => 0x87,
    JVM_OP_i2f => 0x86,
    JVM_OP_i2l => 0x85,
    JVM_OP_i2s => 0x93,
    JVM_OP_iadd => 0x60,
    JVM_OP_iaload => 0x2e,
    JVM_OP_iand => 0x7e,
    JVM_OP_iastore => 0x4f,
    JVM_OP_iconst_0 => 0x03,
    JVM_OP_iconst_1 => 0x04,
    JVM_OP_iconst_2 => 0x05,
    JVM_OP_iconst_3 => 0x06,
    JVM_OP_iconst_4 => 0x07,
    JVM_OP_iconst_5 => 0x08,
    JVM_OP_iconst_m1 => 0x02,
    JVM_OP_idiv => 0x6c,
    JVM_OP_ifeq => 0x99,
    JVM_OP_ifge => 0x9c,
    JVM_OP_ifgt => 0x9d,
    JVM_OP_ifle => 0x9e,
    JVM_OP_iflt => 0x9b,
    JVM_OP_ifne => 0x9a,
    JVM_OP_ifnonnull => 0xc7,
    JVM_OP_ifnull => 0xc6,
    JVM_OP_if_acmpeq => 0xa5,
    JVM_OP_if_acmpne => 0xa6,
    JVM_OP_if_icmpeq => 0x9f,
    JVM_OP_if_icmpge => 0xa2,
    JVM_OP_if_icmpgt => 0xa3,
    JVM_OP_if_icmple => 0xa4,
    JVM_OP_if_icmplt => 0xa1,
    JVM_OP_if_icmpne => 0xa0,
    JVM_OP_iinc => 0x84,
    JVM_OP_iload => 0x15,
    JVM_OP_iload_0 => 0x1a,
    JVM_OP_iload_1 => 0x1b,
    JVM_OP_iload_2 => 0x1c,
    JVM_OP_iload_3 => 0x1d,
    JVM_OP_imul => 0x68,
    JVM_OP_instanceof => 0xc1,
    JVM_OP_invokeinterface => 0xb9,
    JVM_OP_invokespecial => 0xb7,
    JVM_OP_invokestatic => 0xb8,
    JVM_OP_invokevirtual => 0xb6,
    JVM_OP_ior => 0x80,
    JVM_OP_irem => 0x70,
    JVM_OP_ireturn => 0xac,
    JVM_OP_ishl => 0x78,
    JVM_OP_ishr => 0x7a,
    JVM_OP_istore => 0x36,
    JVM_OP_istore_0 => 0x3b,
    JVM_OP_istore_1 => 0x3c,
    JVM_OP_istore_2 => 0x3d,
    JVM_OP_istore_3 => 0x3e,
    JVM_OP_isub => 0x64,
    JVM_OP_iushr => 0x7c,
    JVM_OP_ixor => 0x82,
    JVM_OP_jsr => 0xa8,
    JVM_OP_jsr_w => 0xc9,
    JVM_OP_l2d => 0x8a,
    JVM_OP_l2f => 0x89,
    JVM_OP_l2i => 0x88,
    JVM_OP_ladd => 0x61,
    JVM_OP_laload => 0x2f,
    JVM_OP_land => 0x7f,
    JVM_OP_lastore => 0x50,
    JVM_OP_lcmp => 0x94,
    JVM_OP_lconst_0 => 0x09,
    JVM_OP_lconst_1 => 0x0a,
    JVM_OP_ldc => 0x12,
    JVM_OP_ldc2_w => 0x14,
    JVM_OP_ldc_w => 0x13,
    JVM_OP_ldiv => 0x6d,
    JVM_OP_lload => 0x16,
    JVM_OP_lload_0 => 0x1e,
    JVM_OP_lload_1 => 0x1f,
    JVM_OP_lload_2 => 0x20,
    JVM_OP_lload_3 => 0x21,
    JVM_OP_lmul => 0x69,
    JVM_OP_lneg => 0x75,
    JVM_OP_lookupswitch => 0xab,
    JVM_OP_lor => 0x81,
    JVM_OP_lrem => 0x71,
    JVM_OP_lreturn => 0xad,
    JVM_OP_lshl => 0x79,
    JVM_OP_lshr => 0x7b,
    JVM_OP_lstore => 0x37,
    JVM_OP_lstore_0 => 0x3f,
    JVM_OP_lstore_1 => 0x40,
    JVM_OP_lstore_2 => 0x41,
    JVM_OP_lstore_3 => 0x42,
    JVM_OP_lsub => 0x65,
    JVM_OP_lushr => 0x7d,
    JVM_OP_lxor => 0x83,
    JVM_OP_monitorenter => 0xc2,
    JVM_OP_monitorexit => 0xc3,
    JVM_OP_multianewarray => 0xc5,
    JVM_OP_new => 0xbb,
    JVM_OP_newarray => 0xbc,
    JVM_OP_nop => 0x00,
    JVM_OP_pop => 0x57,
    JVM_OP_pop2 => 0x58,
    JVM_OP_putfield => 0xb5,
    JVM_OP_putstatic => 0xb3,
    JVM_OP_ret => 0xa9,
    JVM_OP_return => 0xb1,
    JVM_OP_saload => 0x35,
    JVM_OP_sastore => 0x56,
    JVM_OP_sipush => 0x11,
    JVM_OP_swap => 0x5f,
    JVM_OP_tableswitch => 0xaa,
    JVM_OP_wide => 0xc4,
    JVM_OP_xxxunusedxxx1 => 0xba,

};

BEGIN {
    my %Opcode;
    my @ops = grep { /^JVM_OP_/ } keys %PJVM::InstructionSet::;
    for my $op (@ops) {
        my ($mnemonic) = $op =~m /^JVM_OP_(.*)$/;
        my $value = __PACKAGE__->$op();
        $Opcode{$value} = $mnemonic;
    }
    
    sub opcode_to_mnemonic {
        my ($op) = @_;
        return $Opcode{$op};
    }
}

require Exporter;

our @EXPORT = qw(
    JVM_OP_aaload
    JVM_OP_aastore
    JVM_OP_aconst_null
    JVM_OP_aload
    JVM_OP_aload_0
    JVM_OP_aload_1
    JVM_OP_aload_2
    JVM_OP_aload_3
    JVM_OP_anewarray
    JVM_OP_areturn
    JVM_OP_arraylength
    JVM_OP_astore
    JVM_OP_astore_0
    JVM_OP_astore_1
    JVM_OP_astore_2
    JVM_OP_astore_3
    JVM_OP_athrow
    JVM_OP_baload
    JVM_OP_bastore
    JVM_OP_bipush
    JVM_OP_caload
    JVM_OP_castore
    JVM_OP_checkcast
    JVM_OP_d2f
    JVM_OP_d2i
    JVM_OP_d2l
    JVM_OP_dadd
    JVM_OP_daload
    JVM_OP_dastore
    JVM_OP_dcmpg
    JVM_OP_dcmpl
    JVM_OP_dconst_0
    JVM_OP_dconst_1
    JVM_OP_ddiv
    JVM_OP_dload
    JVM_OP_dload_0
    JVM_OP_dload_1
    JVM_OP_dload_2
    JVM_OP_dload_3
    JVM_OP_dmul
    JVM_OP_dneg
    JVM_OP_drem
    JVM_OP_dreturn
    JVM_OP_dstore
    JVM_OP_dstore_0
    JVM_OP_dstore_1
    JVM_OP_dstore_2
    JVM_OP_dstore_3
    JVM_OP_dsub
    JVM_OP_dup
    JVM_OP_dup2
    JVM_OP_dup2_x1
    JVM_OP_dup2_x2
    JVM_OP_dup_x1
    JVM_OP_dup_x2
    JVM_OP_f2d
    JVM_OP_f2i
    JVM_OP_f2l
    JVM_OP_fadd
    JVM_OP_faload
    JVM_OP_fastore
    JVM_OP_fcmpg
    JVM_OP_fcmpl
    JVM_OP_fconst_0
    JVM_OP_fconst_1
    JVM_OP_fconst_2
    JVM_OP_fdiv
    JVM_OP_fload
    JVM_OP_fload_0
    JVM_OP_fload_1
    JVM_OP_fload_2
    JVM_OP_fload_3
    JVM_OP_fmul
    JVM_OP_fneg
    JVM_OP_frem
    JVM_OP_freturn
    JVM_OP_fstore
    JVM_OP_fstore_0
    JVM_OP_fstore_1
    JVM_OP_fstore_2
    JVM_OP_fstore_3
    JVM_OP_fsub
    JVM_OP_getfield
    JVM_OP_getstatic
    JVM_OP_goto
    JVM_OP_goto_w
    JVM_OP_i2b
    JVM_OP_i2c
    JVM_OP_i2d
    JVM_OP_i2f
    JVM_OP_i2l
    JVM_OP_i2s
    JVM_OP_iadd
    JVM_OP_iaload
    JVM_OP_iand
    JVM_OP_iastore
    JVM_OP_iconst_0
    JVM_OP_iconst_1
    JVM_OP_iconst_2
    JVM_OP_iconst_3
    JVM_OP_iconst_4
    JVM_OP_iconst_5
    JVM_OP_iconst_m1
    JVM_OP_idiv
    JVM_OP_ifeq
    JVM_OP_ifge
    JVM_OP_ifgt
    JVM_OP_ifle
    JVM_OP_iflt
    JVM_OP_ifne
    JVM_OP_ifnonnull
    JVM_OP_ifnull
    JVM_OP_if_acmpeq
    JVM_OP_if_acmpne
    JVM_OP_if_icmpeq
    JVM_OP_if_icmpge
    JVM_OP_if_icmpgt
    JVM_OP_if_icmple
    JVM_OP_if_icmplt
    JVM_OP_if_icmpne
    JVM_OP_iinc
    JVM_OP_iload
    JVM_OP_iload_0
    JVM_OP_iload_1
    JVM_OP_iload_2
    JVM_OP_iload_3
    JVM_OP_imul
    JVM_OP_instanceof
    JVM_OP_invokeinterface
    JVM_OP_invokespecial
    JVM_OP_invokestatic
    JVM_OP_invokevirtual
    JVM_OP_ior
    JVM_OP_irem
    JVM_OP_ireturn
    JVM_OP_ishl
    JVM_OP_ishr
    JVM_OP_istore
    JVM_OP_istore_0
    JVM_OP_istore_1
    JVM_OP_istore_2
    JVM_OP_istore_3
    JVM_OP_isub
    JVM_OP_iushr
    JVM_OP_ixor
    JVM_OP_jsr
    JVM_OP_jsr_w
    JVM_OP_l2d
    JVM_OP_l2f
    JVM_OP_l2i
    JVM_OP_ladd
    JVM_OP_laload
    JVM_OP_land
    JVM_OP_lastore
    JVM_OP_lcmp
    JVM_OP_lconst_0
    JVM_OP_lconst_1
    JVM_OP_ldc
    JVM_OP_ldc2_w
    JVM_OP_ldc_w
    JVM_OP_ldiv
    JVM_OP_lload
    JVM_OP_lload_0
    JVM_OP_lload_1
    JVM_OP_lload_2
    JVM_OP_lload_3
    JVM_OP_lmul
    JVM_OP_lneg
    JVM_OP_lookupswitch
    JVM_OP_lor
    JVM_OP_lrem
    JVM_OP_lreturn
    JVM_OP_lshl
    JVM_OP_lshr
    JVM_OP_lstore
    JVM_OP_lstore_0
    JVM_OP_lstore_1
    JVM_OP_lstore_2
    JVM_OP_lstore_3
    JVM_OP_lsub
    JVM_OP_lushr
    JVM_OP_lxor
    JVM_OP_monitorenter
    JVM_OP_monitorexit
    JVM_OP_multianewarray
    JVM_OP_new
    JVM_OP_newarray
    JVM_OP_nop
    JVM_OP_pop
    JVM_OP_pop2
    JVM_OP_putfield
    JVM_OP_putstatic
    JVM_OP_ret
    JVM_OP_return
    JVM_OP_saload
    JVM_OP_sastore
    JVM_OP_sipush
    JVM_OP_swap
    JVM_OP_tableswitch
    JVM_OP_wide
    JVM_OP_xxxunusedxxx1
);

our @EXPORT_OK = (@EXPORT, qw(opcode_to_mnemonic));

our %EXPORT_TAGS = (
    all => \@EXPORT_OK
);

our @ISA = qw(Exporter);

1;