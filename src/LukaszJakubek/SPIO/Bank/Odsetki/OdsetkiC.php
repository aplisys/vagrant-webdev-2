<?php
/**
 * Definicja mechanizmu odsetkowego typu C
 */

namespace LukaszJakubek\SPIO\Bank\Odsetki;

use LukaszJakubek\SPIO\Bank\Rachunek\RachunekInterface;

/**
 * Mechanizm obliczania odsetek typu C
 *
 * Wartość oprocentowania inna w każdym z 2 przedziałów wartości salda.
 *
 * @author Łukasz Jakubek <lukasz.jakubek@aplisys.pl>
 */
class OdsetkiC implements OdsetkiInterface
{
    /**
     * stała określająca granicę przedziałów
     */
    const LIMIT = 10000;

    /**
     * Wartość oprocentowania w 1. przedziale w postaci dziesiętnej
     *
     * @var float
     */
    private $oproc0;

    /**
     * Wartość oprocentowania w 2. przedziale w postaci dziesiętnej
     *
     * @var float
     */
    private $oproc1;

    /**
     * Tworzy mechanizm odsetkowy
     *
     * @param float $oprocentowanie0
     * @param float $oprocentowanie1
     */
    public function __construct($oprocentowanie0, $oprocentowanie1)
    {
        $this->oproc0 = $oprocentowanie0;
        $this->oproc1 = $oprocentowanie1;
    }

    /**
     * Oblicza wartośc odsetek
     *
     * @param RachunekInterface $rachunek
     * @return int
     */
    public function oblicz(RachunekInterface $rachunek)
    {
        if ($rachunek->getSaldo() <= 0) {
            return 0;
        }

        if ($rachunek->getSsaldo() < self::LIMIT) {
            return (int) ($this->oproc0 * $rachunek->getSaldo());
        }

        return (int) ($this->oproc0 * self::LIMIT)
            + (int) ($this->oproc1 * ($rachunek->getSaldo() - self::LIMIT));
    }
}
