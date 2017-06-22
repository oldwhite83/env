<?php

namespace Commands;

use GuzzleHttp\Client;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class GetpipMd5 extends Command
{
    protected function configure()
    {
        $this->setName('md5:getpip');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $md5 = md5_file('https://bootstrap.pypa.io/get-pip.py');

        $output->writeln($md5);
    }
}