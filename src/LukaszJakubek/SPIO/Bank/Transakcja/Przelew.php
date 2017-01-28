<?php
/**
 * Definicja transakcji przelewu
 */

namespace LukaszJakubek\SPIO\Bank\Transakcja;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Transakcja przelewu
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class Przelew implements TransakcjaInterface
{
    /**
     * Transakcja wypłaty z rachunku źródłowego
     *
     * @var Wyplata
     */
    private $wyplata;

    /**
     * Transakcja wpłaty na rachunek docelowy
     *
     * @var Wplata
     */
    private $wplata;

    /**
     * Status operacji
     *
     * @var string
     */
    private $status = Status::FRESH;

    /**
     * Konstruktor
     *
     * @param RachunekInterface $rachunekZ Rachunek źródłowy
     * @param RachunekInterface $rachunekDo Rachunek docelowy
     * @param int $kwota Wartość przelewu
     */
    public function __construct(RachunekInterface $rachunekZ, RachunekInterface $rachunekDo, $kwota)
    {
        $this->wyplata = new Wyplata($rachunekZ, $kwota);
        $this->wplata = new Wplata($rachunekDo, $kwota);
    }

    /**
     * Wykonuje transakcję
     *
     * @return bool
     */
    public function execute()
    {
        if ($this->status != Status::FRESH) {
            return false;
        }

        $this->wyplata->execute();

        if ($this->wyplata->getStatus() == Status::EXECUTED) {
            $this->wplata->execute();
        }

        $this->status = ($this->wplata->getStatus() == Status::EXECUTED) ? Status::EXECUTED : Status::FAILED;

        return true;
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
        return sprintf('Przelew [%s]: %s -> %s', $this->status, $this->wyplata, $this->wplata);
    }
}
