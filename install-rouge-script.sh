#!/usr/bin/env bash
set -e
set -o xtrace

# We assume the following dependences are met:
# Python3
# PERL
# CPAN

# 1. Setup ROUGE correctly
cpan install XML::Parser;
cpan install XML::DOM;
(cd ROUGE-1.5.5 && ./ROUGE-1.5.5.pl)
(cd ROUGE-1.5.5/data/WordNet-2.0-Exceptions && ./buildExeptionDB.pl)
(cd ROUGE-1.5.5/data && (rm WordNet-2.0.exc.db; ln -s WordNet-2.0-Exceptions/WordNet-2.0.exc.db WordNet-2.0.exc.db))

# 1.5 Export environment variable used by pyrouge to learn where rouge is installed
echo "export ROUGE_EVAL_HOME=`pwd`/ROUGE-1.5.5/data/" >> ~/.bashrc
echo "export ROUGE_EVAL_HOME=`pwd`/ROUGE-1.5.5/data/" >> ~/.zshrc

# 2. clone & install bheinzerling/pyrouge
git clone //github.com/bheinzerling/pyrouge.git
(cd pyrouge && python3 setup.py install --user)

# write into path
echo "writing into $PATH for bashrc and zshrc..."
echo "PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
echo "PATH=$PATH:$HOME/.local/bin" >> ~/.zshrc


(cd pyrouge/pyrouge && python3 test.py)
