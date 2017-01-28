<?php
/**
 * Definicja tklasy ransakcji naliczenia odsetek
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Transakcja naliczenia odsetek
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class NaliczenieOdsetek implements TransakcjaInterface
{
    /**
     * Rachunek którego dotyczy transakcja
     *
     * @var RachunekInterface
     */
    private $rachunek;

    /**
     * Kwota transakcji. Dodatnia lub ujemna zależnie czy wpływ czy rozchód.
     *
     * @var int
     */
    private $kwota = 0;

    /**
     * Status transakcji
     *
     * @var string
     */
    private $status = Status::FRESH;

    /**
     * Saldo rachunku po operacji
     *
     * @var int
     */
    private $saldo = 0;

    /**
     * Konstruktor
     *
     * @param RachunekInterface $rachunek
     */
    public function __construct(RachunekInterface $rachunek)
    {
        $this->rachunek = $rachunek;
    }

    /**
     * Realizacja transakcji. Zwraca true w przypadku powodzenia.
     *
     * @return bool
     */
    public function execute()
    {
        if ($this->status != Status::FRESH) {
            return false;
        }

        $this->kwota = $this->rachunek->getMechanizmOdsetkowy()->oblicz($this->rachunek);
        $this->rachunek->setSaldo($this->rachunek->getSaldo() + $this->kwota);

        $this->status = Status::EXECUTED;
        $this->saldo = $this->rachunek->getSaldo();

        $this->rachunek->addHistoria($this);
    }

    /**
     * Zwraca status transakcji
     *
     * @return string
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * Cast to string
     *
     * @return string
     */
    public function __toString()
    {
        return sprintf('Naliczenie odsetek [%s]: %.2d, saldo: %.2d', $this->status, $this->kwota, $this->saldo);
    }
}
