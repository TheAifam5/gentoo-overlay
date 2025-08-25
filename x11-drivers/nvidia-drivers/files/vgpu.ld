SECTIONS
{
  .data 0 :
  {
    *(.data .data.*)

    /* Mark beginning of relocated rodata */
    vgpu_unlock_nv_kern_rodata_beg = .;

    /* Move rodata from nv-kernel.o into .data */
    *nv-kernel.o(.rodata*)

    /* Mark end */
    vgpu_unlock_nv_kern_rodata_end = .;
  }

  .rodata 0 :
  {
    /* Take rodata from all other objects EXCEPT nv-kernel.o */
    *(EXCLUDE_FILE (*nv-kernel.o) .rodata .rodata.*)
  }
}

INSERT AFTER .data;