#==============================================================================
# bad1/bad1Data/ovr1/makefile by Alex Chadwick
#
# Generates ovr1.bin, code injected to make the speedometer on Mario Kart
#==============================================================================

$(BUILD_ALL)/numberfont.bin: $(BAD1)/bad1Data/ovr1/numberfont.dds
	$(LOG)
	$Qtail --bytes=17280 $< > $@

$(BUILD_ALL)/kmph.bin: $(BAD1)/bad1Data/ovr1/kmph.dds
	$(LOG)
	$Qtail --bytes=2400 $< > $@

$(BUILD_ALL)/air.bin: $(BAD1)/bad1Data/ovr1/Air.dds
	$(LOG)
	$Qtail --bytes=2304 $< > $@

$(BUILD_ALL)/boost.bin: $(BAD1)/bad1Data/ovr1/boost.dds
	$(LOG)
	$Qtail --bytes=2304 $< > $@

$(BUILD_ALL)/MT.bin: $(BAD1)/bad1Data/ovr1/Blue_MT.dds
	$(LOG)
	$Qtail --bytes=2304 $< > $@

$(BUILD)/ovr1.bin: $(BUILD)/ovr1.elf
	$(LOG)
	$Q$(OC) -O binary $< $@ && chmod a-x $@

$(BUILD)/ovr1.elf: $(BUILD)/ovr1.o $(BUILD)/ovr1.ld
	$(LOG)
	$Q$(LD) -L $(BAD1)/bad1Data/ovr1 -T $(BUILD)/ovr1.ld $< -o $@ \
		&& chmod a-x $@

$(BUILD)/ovr1.o: $(BAD1)/bad1Data/ovr1/ctgp_overlay.s $(BUILD_ALL)/numberfont.bin $(BUILD_ALL)/kmph.bin $(BUILD_ALL)/air.bin $(BUILD_ALL)/boost.bin $(BUILD_ALL)/MT.bin
	$(LOG)
	$Q$(AS) $(SFLAGS) -I $(BAD1)/bad1Data/ovr1/ $< -o $@

$(BUILD)/ovr1.ld: $(BAD1)/bad1Data/ovr1/ovr1.ld $(game).ld
	$(LOG)
	$Qcat $^ > $@
