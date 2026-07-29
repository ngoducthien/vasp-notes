from custodian.custodian import Custodian
from custodian.vasp.handlers import VaspErrorHandler, UnconvergedErrorHandler
from custodian.vasp.handlers import WalltimeHandler
from custodian.vasp.jobs import VaspJob

vasp = "/home/duc/bin/vasp_std_5.4.1"
vasp_cmd = ["srun", vasp]
handlers = [VaspErrorHandler(), UnconvergedErrorHandler(), WalltimeHandler()]

jobs = VaspJob.double_relaxation_run(vasp_cmd, auto_npar=False)
c = Custodian(handlers, jobs, max_errors=10)

# jobs = VaspJob(vasp_cmd, auto_npar=False, auto_gamma=False)
# c = Custodian(handlers, [jobs], max_errors=10)

c.run()

