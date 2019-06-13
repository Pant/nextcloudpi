#!/usr/bin/env python3

import subprocess, re, os, signal

# Signal handler for termination signals
def termination_signal_handler(signalNumber, frame):
    print ('Received:', signalNumber)
    docker_kill()
    raise SystemExit ('Exiting gracefully...')
    return

signal.signal(signal.SIGTERM, termination_signal_handler)
signal.signal(signal.SIGINT, termination_signal_handler)

# Killing the running container of travis-cli
def docker_kill():
    subprocess.run("docker kill travis-cli", shell=True)
    return

def main():
    # Static input
    # Number of stages
    stages = 4
    # Total number of jobs
    jobs = 9
    # Number of jobs per stage
    jobs_stage = []
    jobs_stage.append(3)   # building_part1
    jobs_stage.append(2)   # building_part2
    jobs_stage.append(3)   # testing
    jobs_stage.append(1)   # release

    # Travis cli configuration

    # Build the travis cli docker image
    subprocess.run("cd .travis/travis-cli && docker build . -t travis-cli && cd ../..", shell=True)

    # Restarts need to be made interactively so that travis login is verified
    subprocess.run("docker run --name travis-cli --rm -t -d -v $(pwd):/project --entrypoint=/bin/sh travis-cli", shell=True)

    # Get github token env var
    gh_token = os.environ['GITHUB_TOKEN']

    # Enter the running container with docker exec and login to travis
    command_docker = "docker exec travis-cli travis login --pro --org --github-token "
    command_docker += gh_token
    subprocess.run(command_docker, shell=True)

    # Travis Build

    build_state = ''
    restart_attempt = 0
    # A daemon will run this block of code until the build is successful
    while (build_state != 'passed'):

        flag_attempt = 1

        # Run travis show to get info about the build state and its jobs
        travis_show = subprocess.run("docker exec travis-cli travis show", shell=True, encoding='utf-8', stdout=subprocess.PIPE)
        travis_show = travis_show.stdout.split('\n')

        # Extract status and number of current build
        build_state = travis_show[1].split()[1]
        build_num = travis_show[0].split()[1].lstrip('#').rstrip(':')

        # Extract info about jobs
        jobs = []
        for line in travis_show:
            if line.startswith('#'):
                jobs.append(line)

        for job in jobs:
            if any(status in job for status in ['failed:', 'errored:', 'canceled:']):
                num = job.split()[0].split('.')[1]
                restart_job = 'docker exec travis-cli travis restart '
                restart_job += build_num + '.' + num
                if flag_attempt:
                    restart_attempt+=1
                    print ('\n===Restart attempt no ' + str(restart_attempt) + '===')
                print ('Job ' + build_num + '.' + num + ' has failed. Restarting...')
                subprocess.run(restart_job, shell=True)
                flag_attempt = 0
    
    # Kill travis-cli docker container
    docker_kill()

if __name__ == '__main__':
    try:
        main()
    except:
        docker_kill()
        
