import parsl
from parsl.app.app import python_app, bash_app
from parsl.data_provider.files import File
from path import Path
from parsl.configs.local_threads import config
from parslpw import pwconfig,pwargs
parsl.load(pwconfig)

print("pwconfig loaded")


import time,sys

#========================================
# App to run in Parallel
#========================================
@bash_app
def run_forecast(
        stdout='forecast_app.stdout',
        stderr='forecast_app.stderr',
        inputs=[],
        outputs=[]):

        import os
        setup = os.path.basename(inputs[0])
        config = os.path.basename(inputs[1])
        container = os.path.basename(inputs[2])
        out_file = os.path.splitext(os.path.basename(inputs[0]))[0]+'.log'
        out_dir = os.path.basename(outputs[0])

        run_command = "/bin/bash " + setup + " " + config + " " + container

        # The text here is interpreted by Python
        # (hence the %s string substitution
        # using strings in the tuple at the end of
        # the long text string) and then
        # run as a bash app.
        return '''
        # Run the forecast
        %s > run.log
        # Make output dir and place data to be staged back to PW
        out_base_dir=%s
        out_dir=$out_base_dir/%s/%s
        mkdir -p $out_dir
        mv run.log $out_dir
        cp forecast_app.stderr $out_dir
        cp forecast_app.stdout $out_dir
        ''' % (run_command,out_dir,setup,config)

#==================================
# Workflow
#==================================
def main():
        setup_scripts = pwargs.setup_scripts.split('---')
        config_scripts = pwargs.config_scripts.split('---')
        runs=[]
        for setup_script_name in setup_scripts:
                setup_script = Path(setup_script_name)
                out_dir = Path(pwargs.out_dir)

                for config_script_name in config_scripts:
                        config_script = Path(config_script_name)

                        container_script = Path("container_script.sh")
                        r = run_forecast(
                                inputs=[setup_script,config_script,container_script],
                                outputs=[out_dir])

                        runs.append(r)

        print("Running",len(runs),"FV3 UFS SRW executions...")
        [r.result() for r in runs]
main()
