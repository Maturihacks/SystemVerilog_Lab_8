worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log \
	./src/test/mult_tb.sv

optimize :
	vopt +acc -work ./target/sim_static/work mult_tb -o mult_tb_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work mult_tb \
	-wlf ./target/sim_static/mult_tb.wlf -logfile ./target/log/simulation.log

gui :
	vsim -view ./target/sim_static/mult_tb.wlf

all : setup_sim worklib compile optimize sim
	

clean :
	rm -rf ./target

setup_sim :
	mkdir -p target/log
	mkdir -p target/sim_static