# Define default target
all:
	processing-java --sketch='/Users/kewing/Desktop/splash' --run

# Define custom target for running multiple times
run:
	$(eval N := $(filter-out $@,$(MAKECMDGOALS)))
	@$(foreach var,$(shell seq $(N)),processing-java --sketch='/Users/kewing/Desktop/splash' --run;)

# Define clean target
clean:
	rm -rf ./output/*

# This will prevent make from getting confused by any command line arguments
%:
	@: