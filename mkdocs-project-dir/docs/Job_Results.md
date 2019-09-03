# Where do my results go?

After submitting your job you can use the command 'qstat' to view the status of the job you have submitted. Once you can no longer see your job on the qstat list this means your job has completed to view the jobs that have completed you can run 'jobhist'. There are various ways of monitoring the output of your job.

## Output and error files
When writing up your job script you specifiy your working directory, within this working directory you can find your output(.o) and error(.e) files. These files will contain any possible error your jobs may have come across or any output that was excepted from your job.

## Grid engine
The following options can be used to submit and monitor a job<br />
### Qsub <br />
This command submits your job to the batch queue. You can also specify variables on your jacket in your qsub command which will overide what is in your job script. <br />
qsub -N NewName myscript.sh <br />
qsub -l h_rt=24:0:0 myscript.sh <br />
qsub -hold_jid 12345 myscript.sh <br />
qsub -ac allow=XYZ myscript.sh <br />

### Qstat <br /> 
This command shows that status oof your job. When you run qstat with no options all of your jobs currently running will be displayed. By adding in the option `-f -j <job-ID>` you will get more detail on the specified job.

### Qdel <br />
This command deletes your job from the queue. When deleting a job will need to run `qdel <job-ID>`, however `qdel '*'` can be used to delete all jobs. To delete a batch of jobs, creating a file with the list of job IDs that you would like to delete and placing it in the following commands will delete the following jobs: `cat <filename> | xargs qdel`

## Qsub emailing
We also have a mailing system that can be implemented to send emails with reminders of the status of your job through qsub. When you use qsub to submit your job you can use the option `-m`. You can specify when you want an email sent to you by using the below options after `qsub -m`:
<br /><br />
b-Mail is sent at the beginning of the job. <br />
e-Mail is sent at the end of the job. <br />
a-Mail is sent when the job is aborted or rescheduled. <br />
s-Mail is sent when the job is suspended. <br />
n-No mail is sent. <br />


