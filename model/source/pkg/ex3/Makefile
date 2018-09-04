# $Header: /u/gcmpack/MITgcm/pkg/ex3/Makefile,v 1.2 2005/10/16 06:55:48 edhill Exp $
# $Name:  $

RL_FILES = \
ex3_send_rl1.F ex3_send_rl2.F \
ex3_recv_rl1.F ex3_recv_rl2.F \
ex3_xy_rl.F

RS_FILES = \
ex3_send_rs1.F ex3_send_rs2.F \
ex3_recv_rs1.F ex3_recv_rs2.F \
ex3_xy_rs.F

R4_FILES = \
ex3_send_r41.F ex3_send_r42.F \
ex3_recv_r41.F ex3_recv_r42.F \
ex3_xy_r4.F

R8_FILES = \
ex3_send_r81.F ex3_send_r82.F \
ex3_recv_r81.F ex3_recv_r82.F \
ex3_xy_r8.F


all: $(RL_FILES) $(RS_FILES) $(R4_FILES) $(R8_FILES)

CLEAN: clean
Clean: clean
clean:
	-rm -f $(RL_FILES) $(RS_FILES) $(R4_FILES) $(R8_FILES)

# ex3_xy_rx
ex3_xy_rl.F: ex3_xy_rx.template
	sed 's/RX/RL/g' ex3_xy_rx.template > $@
ex3_xy_rs.F: ex3_xy_rx.template
	sed 's/RX/RS/g' ex3_xy_rx.template > $@
ex3_xy_r4.F: ex3_xy_rx.template
	sed 's/RX/R4/g' ex3_xy_rx.template > $@
ex3_xy_r8.F: ex3_xy_rx.template
	sed 's/RX/R8/g' ex3_xy_rx.template > $@

# ex3_send_rx1
ex3_send_rl1.F: ex3_send_rx1.template
	sed 's/RX/RL/g' ex3_send_rx1.template > $@
ex3_send_rs1.F: ex3_send_rx1.template
	sed 's/RX/RS/g' ex3_send_rx1.template > $@
ex3_send_r41.F: ex3_send_rx1.template
	sed 's/RX/R4/g' ex3_send_rx1.template > $@
ex3_send_r81.F: ex3_send_rx1.template
	sed 's/RX/R8/g' ex3_send_rx1.template > $@

# ex3_send_rx2
ex3_send_rl2.F: ex3_send_rx2.template
	sed 's/RX/RL/g' ex3_send_rx2.template > $@
ex3_send_rs2.F: ex3_send_rx2.template
	sed 's/RX/RS/g' ex3_send_rx2.template > $@
ex3_send_r42.F: ex3_send_rx2.template
	sed 's/RX/R4/g' ex3_send_rx2.template > $@
ex3_send_r82.F: ex3_send_rx2.template
	sed 's/RX/R8/g' ex3_send_rx2.template > $@

# ex3_recv_rx1
ex3_recv_rl1.F: ex3_recv_rx1.template
	sed 's/RX/RL/g' ex3_recv_rx1.template > $@
ex3_recv_rs1.F: ex3_recv_rx1.template
	sed 's/RX/RS/g' ex3_recv_rx1.template > $@
ex3_recv_r41.F: ex3_recv_rx1.template
	sed 's/RX/R4/g' ex3_recv_rx1.template > $@
ex3_recv_r81.F: ex3_recv_rx1.template
	sed 's/RX/R8/g' ex3_recv_rx1.template > $@

# ex3_recv_rx2
ex3_recv_rl2.F: ex3_recv_rx2.template
	sed 's/RX/RL/g' ex3_recv_rx2.template > $@
ex3_recv_rs2.F: ex3_recv_rx2.template
	sed 's/RX/RS/g' ex3_recv_rx2.template > $@
ex3_recv_r42.F: ex3_recv_rx2.template
	sed 's/RX/R4/g' ex3_recv_rx2.template > $@
ex3_recv_r82.F: ex3_recv_rx2.template
	sed 's/RX/R8/g' ex3_recv_rx2.template > $@

