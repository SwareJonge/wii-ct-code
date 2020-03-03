# =============================================================================
#  ctgp_overlay.s
#   by Chadderz
#   Version 0.2 (2012-09-21)
# =============================================================================
#  Constructs a speedometer on mario kart wii
#  Changelog
#   v0.2 (2012-09-21): Updated to work with karts
#   v0.1 (2012-03-20): Initial
# =============================================================================
_overlayStart:
# Header
.ascii "OVR1"
.int _overlayEnd-_overlayStart
.int 0
.int copy-_start

# =============================================================================
#  draw(screenWidth, screenHeight, screenAddress)
#   Alter this method to achieve drawing
# =============================================================================


.include "overlay.s"

methodDraw:
# Stack frame
stwu r1,-16(r1)
mflr r3
stw r3,20(r1)

lis r3,SpeedCounter@ha
lwz r4,SpeedCounter@l(r3)
cmpwi r4,0
ble 1f
cmpwi r4,3
li r4,0
stw r4,0xde8(r3)
bgt 1f

# Drawing here!
bl 0f
.incbin "build/kmph.bin"
0:
mflr r7
subi r3,screenWidth,88
subi r4,screenHeight,48
li r5, 40
li r6, 15
bl methodDrawImage

lis r3,SpeedValue@ha
lwz r3,SpeedValue@l(r3)
subi r4,screenWidth,48
subi r5,screenHeight,72
bl methodDrawNumber

# Draw Airtime
lis r3,SpeedValue@ha
lwz r3,0x1660(r3)
subi r4,screenWidth,48
subi r5,screenHeight,216
bl methodDrawNumber

# Draw MT
lis r3,SpeedValue@ha
lwz r3,0x1668(r3)
subi r4,screenWidth,48
subi r5,screenHeight,188
bl methodDrawNumber

# Draw Boost Timer
lis r3,SpeedValue@ha
lwz r3,0x1664(r3)
subi r4,screenWidth,48
subi r5,screenHeight,160
bl methodDrawNumber

1:

# Stack cleanup
lwz r3,20(r1)
mtlr r3
addi r1,r1,16
blr

# =============================================================================
#  speedo copy
#  bl from 0x807eefac (to +52e0)
# =============================================================================
copy:
lis r15,playerBase@ha
lwz r15,playerBase@l(r15)
lwz r15,32(r15)
mulli r19,r0,4
add r15,r15,r19
lwz r15,0(r15)
lwz r15,16(r15)
lwz r11,16(r15)
lwz r15,16(r15)
lwz r3,playerDataUNK@l(r31)
lis r19,SpeedCounter@ha
lwz r15,36(r15)
stw r15,SpeedFloat@l(r19)
lfs f0,SpeedFloat@l(r19)
fabs f0,f0
li r15,SpeedValue@l
fctiw f0,f0
stfiwx f0,r15,r19
lwz r15,SpeedCounter@l(r19)
cmpwi r15,3
blt 0f
li r15,4
b 1f
0:
li r15,3
1:
stw r15,SpeedCounter@l(r19)

# Airtime
lhz r12, 0x21A(r11)
stw r12, 0x1660(r19)

# Boost Timers
lhz r12, 0x110(r11) # Load Mushroom boost into r12
cmpwi r12, 0x0 # If not zero, we don't need to read Other Boost timers since mushroom boost is best, follow skip_other_boost branch
bne- skip_other_boost

lhz r12, 0x114(r11) # Load Trick boost into r12
cmpwi r12, 0x0 # If not zero, we don't need to read MT Boost time, follow skip_MT_boost branch
bne- skip_MT_boost

lhz r12, 0x10C(r11)

skip_MT_boost:
skip_other_boost:
stw r12, 0x1664(r19) # Store boost timers to 0x8001664

# MT Charge values
lhz r12, 0x14C (r11) # First Load the Orange MT value
cmpwi r12, 0x0 # If not zero, we don't need to read Other MT values, follow skip_other_MTs branch
bne- skip_other_MTs

lhz r12, 0x100 (r11) # First Load the Orange MT value
cmpwi r12, 0x0
bne- skip_blue # If not zero, we don't need to read Blue MT, follow skip_blue branch

lhz r12, 0xFE (r11) # If zero, read Blue MT instead of Orange MT

skip_blue:
skip_other_MTs:
stw r12, 0x1668(r19)

blr

_overlayEnd:
